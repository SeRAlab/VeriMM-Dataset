`timescale 1ns/1ps

module IR_tb;

    // Testbench signals (sequential circuit)
    reg EI;
    reg LI;
    reg [8:0] SRAM_IN;
    reg clk;
    wire [4:0] IR_OUT_1;
    wire [3:0] IR_OUT_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IR dut (
        .EI(EI),
        .LI(LI),
        .SRAM_IN(SRAM_IN),
        .clk(clk),
        .IR_OUT_1(IR_OUT_1),
        .IR_OUT_2(IR_OUT_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        LI = 1;
        EI = 0;
        SRAM_IN = 9'h000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Load and Full Output", test_num);
        reset_dut();


        SRAM_IN = 9'b11010_0101;
        LI = 0;
        @(posedge clk);
        #1;
        LI = 1;
        EI = 1;
        #1;

        #1;


        check_outputs(5'b11010, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Load and Masked Output", test_num);
        reset_dut();


        SRAM_IN = 9'h1FF;
        LI = 0;
        @(posedge clk);
        #1;
        LI = 1;
        EI = 0;
        #1;

        #1;


        check_outputs(5'h1F, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Retention Check (LI=1)", test_num);
        reset_dut();


        SRAM_IN = 9'h0AA;
        LI = 0;
        @(posedge clk);
        #1;


        LI = 1;
        SRAM_IN = 9'h1FF;
        EI = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'h0A, 4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Dynamic EI Toggling", test_num);
        reset_dut();

        SRAM_IN = 9'h155;
        LI = 0;
        @(posedge clk);
        #1;
        LI = 1;


        EI = 1;
        #1;
        if (IR_OUT_2 !== 4'h5) begin
             $display("Subtest EI=1 failed");
        end


        EI = 0;
        #1;

        #1;


        check_outputs(5'h0A, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Load All Zeros", test_num);
        reset_dut();

        SRAM_IN = 9'h000;
        LI = 0;
        @(posedge clk);
        #1;
        LI = 1;
        EI = 1;
        #1;

        #1;


        check_outputs(5'h00, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IR Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_IR_OUT_1;
        input [3:0] expected_IR_OUT_2;
        begin
            if (expected_IR_OUT_1 === (expected_IR_OUT_1 ^ IR_OUT_1 ^ expected_IR_OUT_1) &&
                expected_IR_OUT_2 === (expected_IR_OUT_2 ^ IR_OUT_2 ^ expected_IR_OUT_2)) begin
                $display("PASS");
                $display("  Outputs: IR_OUT_1=%h, IR_OUT_2=%h",
                         IR_OUT_1, IR_OUT_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IR_OUT_1=%h, IR_OUT_2=%h",
                         expected_IR_OUT_1, expected_IR_OUT_2);
                $display("  Got:      IR_OUT_1=%h, IR_OUT_2=%h",
                         IR_OUT_1, IR_OUT_2);
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
        $dumpvars(0,EI, LI, SRAM_IN, clk, IR_OUT_1, IR_OUT_2);
    end

endmodule
