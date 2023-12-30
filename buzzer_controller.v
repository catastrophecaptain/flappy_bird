`define c3 191970
`define d3 171154
`define e3 152651
`define f3 144170
`define g3 127980
`define le 121041
`define a3 114103
`define b3 101767
`define c4 95600
`define d4 84806
`define me 80180
`define e4 75554
`define f4 71700
`define g4 63990
`define a4 56280
`define b4 50112
`define c5 47800
`define d5 42403
`define e5 37777
`define f5 35464
`define g5 31609
`define a5 27754
`define b5 24670
`define xz 770
`timescale 1ns/1ps
module BuzzerController(
    input wire clk,
    input wire rst,
    output reg buzzer
);

// 音符的数量
parameter NOTE_COUNT = 79;

// 音符的振动周期和持续时间
reg [19:0] note_periods[78:0];
reg [19:0] note_durations[78:0];

// 当前播放的音符和时间计数器
integer current_note;
integer note_counter;
integer duration_counter;

// 初始化 buzzer 为 0
initial begin
    buzzer = 0;
    current_note = 0;
    note_counter = 0;
    duration_counter = 0;
end


initial begin
    note_periods[0] <= `c4; note_periods[1] <= `d4; note_periods[2] <= `e4;note_periods[3] <= `xz;note_periods[4] <= `e4;
    note_periods[5] <= `xz; note_periods[6] <= `e4; note_periods[7] <= `d4;note_periods[8] <= `e4;note_periods[9] <= `f4;
    note_periods[10] <= `xz; note_periods[11] <= `f4; note_periods[12] <= `xz;note_periods[13] <= `f4;note_periods[14] <= `e4;
    note_periods[15] <= `f4; note_periods[16] <= `g4; note_periods[17] <= `xz;note_periods[18] <= `g4;note_periods[19] <= `d4;
    note_periods[20] <= `f4; note_periods[21] <= `e4; note_periods[22] <= `d4;note_periods[23] <= `e4;note_periods[24] <= `d4;
    note_periods[25] <= `c4; note_periods[26] <= `xz; note_periods[27] <= `c4;note_periods[28] <= `xz;note_periods[29] <= `c4;
    note_periods[30] <= `a3; note_periods[31] <= `c4; note_periods[32] <= `d4;note_periods[33] <= `xz;note_periods[34] <= `d4;
    note_periods[35] <= `xz; note_periods[36] <= `e4; note_periods[37] <= `c4;note_periods[38] <= `e4;note_periods[39] <= `f4;
    note_periods[40] <= `g4; note_periods[41] <= `d4; note_periods[42] <= `xz;note_periods[43] <= `d4;note_periods[44] <= `e4;
    note_periods[45] <= `f4; note_periods[46] <= `g4; note_periods[47] <= `xz;note_periods[48] <= `g4;note_periods[49] <= `xz;
    note_periods[50] <= `g4; note_periods[51] <= `a4; note_periods[52] <= `b4;note_periods[53] <= `g4;note_periods[54] <= `xz;
    note_periods[55] <= `g4; note_periods[56] <= `a4; note_periods[57] <= `b4;note_periods[58] <= `c5;note_periods[59] <= `g4;
    note_periods[60] <= `xz; note_periods[61] <= `g4; note_periods[62] <= `f4;note_periods[63] <= `e4;note_periods[64] <= `g4;
    note_periods[65] <= `d5; note_periods[66] <= `g4; note_periods[67] <= `c5;note_periods[68] <= `b4;note_periods[69] <= `c5;
    note_periods[70] <= `a4; note_periods[71] <= `d5; note_periods[72] <= `c5;note_periods[73] <= `b4;note_periods[74] <= `a4;
    note_periods[75] <= `b4; note_periods[76] <= `xz; note_periods[77] <= `c5;note_periods[78] <= `xz;    
end
initial begin
    note_durations[0] <= 12500;note_durations[1] <= 6250;note_durations[2] <= 12500;note_durations[3] <= 6250;
    note_durations[4] <= 18750;note_durations[5] <= 10937;note_durations[6] <= 6250;note_durations[7] <= 12500;
    note_durations[8] <= 6250;note_durations[9] <= 18750;note_durations[10] <= 12500;note_durations[11] <= 6250;
    note_durations[12] <= 12500;note_durations[13] <= 6250;note_durations[14] <= 12500;note_durations[15] <= 6250;
    note_durations[16] <= 18750;note_durations[17] <= 6250;note_durations[18] <= 17187.5;note_durations[19] <= 17187.5;
    note_durations[20] <= 18750;note_durations[21] <= 12500;note_durations[22] <= 6250;note_durations[23] <= 37500;
    note_durations[24] <= 18750;note_durations[25] <= 12500;note_durations[26] <= 6250;note_durations[27] <= 17187.5;
    note_durations[28] <= 6250;note_durations[29] <= 18750;note_durations[30] <= 12500;note_durations[31] <= 6250;
    note_durations[32] <= 12500;note_durations[33] <= 6250;note_durations[34] <= 12500;note_durations[35] <= 6250;
    note_durations[36] <= 18750;note_durations[37] <= 6250;note_durations[38] <= 17187.5;note_durations[39] <= 18750;
    note_durations[40] <= 12500;note_durations[41] <= 6250;note_durations[42] <= 37500;note_durations[43] <= 18750;
    note_durations[44] <= 12500;note_durations[45] <= 6250;note_durations[46] <= 17187.5;note_durations[47] <= 6250;
    note_durations[48] <= 18750;note_durations[49] <= 12500;note_durations[50] <= 6250;note_durations[51] <= 18750;
    note_durations[52] <= 18750;note_durations[53] <= 18750;note_durations[54] <= 18750;note_durations[55] <= 90000;
    note_durations[56] <= 6250;note_durations[57] <= 12500;note_durations[58] <= 6250;note_durations[59] <= 17187.5;
    note_durations[60] <= 6250;note_durations[61] <= 17187.5;note_durations[62] <= 6250;note_durations[63] <= 18750;
    note_durations[64] <= 12500;note_durations[65] <= 6250;note_durations[66] <= 27500;note_durations[67] <= 12500;
    note_durations[68] <= 6250;note_durations[69] <= 12500;note_durations[70] <= 6250;note_durations[71] <= 18750;
    note_durations[72] <= 18750;note_durations[73] <= 6250;note_durations[74] <= 17187.5;note_durations[75] <= 18750;
    note_durations[76] <= 37500;note_durations[77] <= 18750;note_durations[78] <= 12500; 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 当复位信号为高时，将 buzzer 和计数器重置
        buzzer <= 0;
        current_note <= 0;
        note_counter <= 0;
        duration_counter <= 0;
    end else begin
        // 播放音乐
        if (duration_counter >= 1000*note_durations[current_note]) begin
            // 如果当前音符已经播放完毕，切换到下一个音符
            current_note <= (current_note + 1) % NOTE_COUNT;
            note_counter <= 0;
            duration_counter <= 0;
        end else if (note_counter >= note_periods[current_note]) begin
            // 如果当前音符的一个周期已经完成，反转 buzzer 的状态
            buzzer <= ~buzzer;
            note_counter <= 0;
        end else begin
            // 否则，增加计数器
            note_counter <= note_counter + 1;
            duration_counter <= duration_counter + 1;
        end
    end
end

endmodule