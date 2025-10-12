# 1. Внешний тактовый сигнал 50 МГц (с кварцевого генератора)
create_clock -name clk50 -period 20.000 [get_ports clk_50]

# 2. Описание PLL 
#    Автоматически создаются derived clocks для выходов PLL.
derive_pll_clocks

# 3. Автоматическое описание всех неопределённостей 
#(джиттер, скосы, и т.д.)
derive_clock_uncertainty

# 4. Исключение асинхронного сброса из анализа
set_false_path -from [get_ports arstn]

# 5. Выходные сигналы считаем асинхронными, 
#исключаем их из STA
set_false_path -to [get_ports {out[*]}]
