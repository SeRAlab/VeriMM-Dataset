`timescale 1ns/1ps

module RMON_CTRL_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] CPU_rd_addr;
    reg CPU_rd_apply;
    reg Clk;
    reg [31:0] Douta;
    reg [4:0] Reg_addr_0;
    reg [4:0] Reg_addr_1;
    reg Reg_apply_0;
    reg Reg_apply_1;
    reg [15:0] Reg_data_0;
    reg [15:0] Reg_data_1;
    reg Reset;
    wire [5:0] Addra;
    wire [31:0] CPU_rd_dout;
    wire CPU_rd_grant;
    wire [31:0] Dina;
    wire Reg_next_0;
    wire Reg_next_1;
    wire Wea;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RMON_CTRL dut (
        .CPU_rd_addr(CPU_rd_addr),
        .CPU_rd_apply(CPU_rd_apply),
        .Clk(Clk),
        .Douta(Douta),
        .Reg_addr_0(Reg_addr_0),
        .Reg_addr_1(Reg_addr_1),
        .Reg_apply_0(Reg_apply_0),
        .Reg_apply_1(Reg_apply_1),
        .Reg_data_0(Reg_data_0),
        .Reg_data_1(Reg_data_1),
        .Reset(Reset),
        .Addra(Addra),
        .CPU_rd_dout(CPU_rd_dout),
        .CPU_rd_grant(CPU_rd_grant),
        .Dina(Dina),
        .Reg_next_0(Reg_next_0),
        .Reg_next_1(Reg_next_1),
        .Wea(Wea)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RMON_CTRL Testbench");
        $display("========================================");


        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [5:0] expected_Addra;
        input [31:0] expected_CPU_rd_dout;
        input expected_CPU_rd_grant;
        input [31:0] expected_Dina;
        input expected_Reg_next_0;
        input expected_Reg_next_1;
        input expected_Wea;
        begin
            if (expected_Addra === (expected_Addra ^ Addra ^ expected_Addra) &&
                expected_CPU_rd_dout === (expected_CPU_rd_dout ^ CPU_rd_dout ^ expected_CPU_rd_dout) &&
                expected_CPU_rd_grant === (expected_CPU_rd_grant ^ CPU_rd_grant ^ expected_CPU_rd_grant) &&
                expected_Dina === (expected_Dina ^ Dina ^ expected_Dina) &&
                expected_Reg_next_0 === (expected_Reg_next_0 ^ Reg_next_0 ^ expected_Reg_next_0) &&
                expected_Reg_next_1 === (expected_Reg_next_1 ^ Reg_next_1 ^ expected_Reg_next_1) &&
                expected_Wea === (expected_Wea ^ Wea ^ expected_Wea)) begin
                $display("PASS");
                $display("  Outputs: Addra=%h, CPU_rd_dout=%h, CPU_rd_grant=%b, Dina=%h, Reg_next_0=%b, Reg_next_1=%b, Wea=%b",
                         Addra, CPU_rd_dout, CPU_rd_grant, Dina, Reg_next_0, Reg_next_1, Wea);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Addra=%h, CPU_rd_dout=%h, CPU_rd_grant=%b, Dina=%h, Reg_next_0=%b, Reg_next_1=%b, Wea=%b",
                         expected_Addra, expected_CPU_rd_dout, expected_CPU_rd_grant, expected_Dina, expected_Reg_next_0, expected_Reg_next_1, expected_Wea);
                $display("  Got:      Addra=%h, CPU_rd_dout=%h, CPU_rd_grant=%b, Dina=%h, Reg_next_0=%b, Reg_next_1=%b, Wea=%b",
                         Addra, CPU_rd_dout, CPU_rd_grant, Dina, Reg_next_0, Reg_next_1, Wea);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CPU_rd_addr, CPU_rd_apply, Clk, Douta, Reg_addr_0, Reg_addr_1, Reg_apply_0, Reg_apply_1, Reg_data_0, Reg_data_1, Reset, Addra, CPU_rd_dout, CPU_rd_grant, Dina, Reg_next_0, Reg_next_1, Wea);
    end

endmodule
