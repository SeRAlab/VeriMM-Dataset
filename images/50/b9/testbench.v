`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        data_in = 16'h0;
        #7;
        reset = 0;
        #3;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying initial reset state", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying synchronous load", test_num);
        reset_dut();

        load = 1;
        data_in = 16'hA5A5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying single shift left operation", test_num);
        reset_dut();


        load = 1;
        data_in = 16'h0001;
        @(posedge clk);
        #1;


        load = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h0002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying 8 shifts left (Byte swap behavior)", test_num);
        reset_dut();


        load = 1;
        data_in = 16'h00FF;
        @(posedge clk);
        #1;


        load = 0;
        repeat(8) @(posedge clk);
        #1;


        #1;



        check_outputs(16'hFF00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying shifting MSB out of bounds", test_num);
        reset_dut();


        load = 1;
        data_in = 16'h8000;
        @(posedge clk);
        #1;


        load = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verifying load priority during active shifting", test_num);
        reset_dut();


        load = 1;
        data_in = 16'h1111;
        @(posedge clk);
        #1;


        load = 0;
        repeat(2) @(posedge clk);
        #1;


        load = 1;
        data_in = 16'hBEEF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hBEEF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verifying asynchronous reset mid-cycle", test_num);
        reset_dut();


        load = 1;
        data_in = 16'hFFFF;
        @(posedge clk);
        #1;


        #3;
        reset = 1;
        #1;

        #1;


        check_outputs(16'h0000);


        reset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, load, reset, q);
    end

endmodule
