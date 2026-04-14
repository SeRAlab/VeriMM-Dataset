`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    wire [79:0] str;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .str(str)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            addr = 32'h00000000;



            #1;




            check_outputs(80'h30783030303030303030);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            addr = 32'hFFFFFFFF;



            #1;




            check_outputs(80'h30784646464646464646);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            addr = 32'h12345678;



            #1;




            check_outputs(80'h30783132333435363738);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            addr = 32'h9ABCDEF0;



            #1;




            check_outputs(80'h30783941424344454630);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            addr = 32'h55AAAA55;



            #1;




            check_outputs(80'h30783535414141413535);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            addr = 32'hDEADBEEF;



            #1;




            check_outputs(80'h30784445414442454546);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            addr = 32'hCAFEB0BA;



            #1;




            check_outputs(80'h30784341464542304241);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            addr = 32'h0000FFFF;

            #1;


            check_outputs(80'h30783030303046464646);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            addr = 32'h87654321;

            #1;


            check_outputs(80'h30783837363534333231);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            addr = 32'hA1B2C3D4;

            #1;


            check_outputs(80'h30784131423243334434);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [79:0] expected_str;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_str === (expected_str ^ str ^ expected_str)) begin
                $display("PASS");
                $display("  Outputs: str=%h",
                         str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: str=%h",
                         expected_str);
                $display("  Got:      str=%h",
                         str);
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
