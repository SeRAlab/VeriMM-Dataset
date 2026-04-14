`timescale 1ns/1ps

module sd_card_interface_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CMD;
    reg [7:0] DATA_IN;
    reg RESET;
    wire [7:0] DATA_OUT;
    wire READY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_interface dut (
        .CLK(CLK),
        .CMD(CMD),
        .DATA_IN(DATA_IN),
        .RESET(RESET),
        .DATA_OUT(DATA_OUT),
        .READY(READY)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            CMD = 0;
            DATA_IN = 0;
            @(posedge CLK);
            #2;
            RESET = 0;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            CMD = 1;
            DATA_IN = 8'hA5;
            @(posedge CLK);
            #2;


            CMD = 0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'hA5, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Internal Data", test_num);
            reset_dut();


            CMD = 1;
            DATA_IN = 8'h11;
            @(posedge CLK);
            #2;


            DATA_IN = 8'h22;
            @(posedge CLK);
            #2;


            CMD = 0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'h22, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior Check", test_num);
            reset_dut();


            CMD = 1;
            DATA_IN = 8'hFF;
            @(posedge CLK);
            #2;


            reset_dut();


            CMD = 0;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'h00, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Reads", test_num);
            reset_dut();


            CMD = 1;
            DATA_IN = 8'h55;
            @(posedge CLK);
            #2;


            CMD = 0;
            @(posedge CLK);
            #2;


            @(posedge CLK);
            #2;


            #1;



            check_outputs(8'h55, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write/Read Zero Value", test_num);
            reset_dut();


            CMD = 1;
            DATA_IN = 8'h00;
            @(posedge CLK);
            #2;


            CMD = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'h00, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_interface Testbench");
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
        input [7:0] expected_DATA_OUT;
        input expected_READY;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_READY === (expected_READY ^ READY ^ expected_READY)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, READY=%b",
                         DATA_OUT, READY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, READY=%b",
                         expected_DATA_OUT, expected_READY);
                $display("  Got:      DATA_OUT=%h, READY=%b",
                         DATA_OUT, READY);
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
        $dumpvars(0,CLK, CMD, DATA_IN, RESET, DATA_OUT, READY);
    end

endmodule
