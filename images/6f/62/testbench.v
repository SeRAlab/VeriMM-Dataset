`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] DIN;
    reg [63:0] LOAD;
    reg RESETn;
    wire [1535:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DIN(DIN),
        .LOAD(LOAD),
        .RESETn(RESETn),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        LOAD = 0;
        forever #5 LOAD = ~LOAD;
    end

        task reset_dut;

        begin
            RESETn = 0;
            DIN = 0;
            LOAD = 0;
            #20;
            RESETn = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1536'h0);
        end
        endtask

    task testcase002;

        reg [1535:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data into Register 0", test_num);
            reset_dut();
            DIN = 24'hABCDEF;
            LOAD = 64'h1;
            #10;
            LOAD = 0;
            #10;
            expected = 0;
            expected[23:0] = 24'hABCDEF;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [1535:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data into Register 63", test_num);
            reset_dut();
            DIN = 24'h123456;
            LOAD = (64'h1 << 63);
            #10;
            LOAD = 0;
            #10;
            expected = 0;
            expected[1535:1512] = 24'h123456;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [1535:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Load into Reg 1, 2, and 3", test_num);
            reset_dut();
            DIN = 24'hAAAAAA;
            LOAD = 64'hE;
            #10;
            LOAD = 0;
            #10;
            expected = 0;
            expected[47:24] = 24'hAAAAAA;
            expected[71:48] = 24'hAAAAAA;
            expected[95:72] = 24'hAAAAAA;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [1535:0] expected;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Writes to Reg 10 then Reg 20", test_num);
            reset_dut();


            DIN = 24'h555555;
            LOAD = (64'h1 << 10);
            #10;


            DIN = 24'hCCCCCC;
            LOAD = (64'h1 << 20);
            #10;

            LOAD = 0;
            #10;

            expected = 0;
            expected[10*24 +: 24] = 24'h555555;
            expected[20*24 +: 24] = 24'hCCCCCC;
            #1;

            check_outputs(expected);
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
        input [1535:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,DIN, LOAD, RESETn, DOUT);
    end

endmodule
