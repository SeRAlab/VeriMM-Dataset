`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WE;
    reg [4:0] address;
    reg clock;
    reg [7:0] dataIn;
    reg testStart;
    wire [7:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WE(WE),
        .address(address),
        .clock(clock),
        .dataIn(dataIn),
        .testStart(testStart),
        .dataOut(dataOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            WE = 0;
            address = 5'b0;
            dataIn = 8'b0;
            testStart = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            WE = 1;
            address = 5'd10;
            dataIn = 8'hA5;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Write/Read", test_num);
            reset_dut();


            WE = 1;
            address = 5'd31;
            dataIn = 8'hFF;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd31;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite", test_num);
            reset_dut();


            WE = 1;
            address = 5'd15;
            dataIn = 8'h11;
            @(posedge clock);
            #1;


            WE = 1;
            address = 5'd15;
            dataIn = 8'h22;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd15;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable (WE) Control", test_num);
            reset_dut();


            WE = 1;
            address = 5'd20;
            dataIn = 8'hCC;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd20;
            dataIn = 8'hDD;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd20;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initialization Pulse and subsequent write", test_num);
            reset_dut();


            testStart = 1;
            @(posedge clock);
            #1;
            testStart = 0;


            WE = 1;
            address = 5'd0;
            dataIn = 8'h77;
            @(posedge clock);
            #1;


            WE = 0;
            address = 5'd0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_dataOut;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h",
                         expected_dataOut);
                $display("  Got:      dataOut=%h",
                         dataOut);
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
        $dumpvars(0,WE, address, clock, dataIn, testStart, dataOut);
    end

endmodule
