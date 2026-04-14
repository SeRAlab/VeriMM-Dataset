`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg RE;
    reg WE;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .RE(RE),
        .WE(WE),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (0xABCD)", test_num);


            WE = 1; RE = 0; data_in = 16'hABCD;
            #10;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write and Read Alternating Bits (0x5555)", test_num);


            WE = 1; RE = 0; data_in = 16'h5555;
            #10;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence during Idle (0x1234)", test_num);


            WE = 1; RE = 0; data_in = 16'h1234;
            #10;


            WE = 0; RE = 0;
            #20;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwriting Existing Data", test_num);


            WE = 1; RE = 0; data_in = 16'hAAAA;
            #10;


            WE = 1; RE = 0; data_in = 16'hFFFF;
            #10;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Test", test_num);


            WE = 1; RE = 0; data_in = 16'h0000;
            #10;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Test", test_num);


            WE = 1; RE = 0; data_in = 16'hFFFF;
            #10;


            WE = 0; RE = 1;
            #10;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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

endmodule
