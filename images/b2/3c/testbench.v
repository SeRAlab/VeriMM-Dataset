`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg efe;
    reg fci;
    reg ife;
    reg [15:0] in;
    wire fco;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .efe(efe),
        .fci(fci),
        .ife(ife),
        .in(in),
        .fco(fco),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Passthrough mode (efe=0, ife=0)", test_num);
            efe = 0;
            ife = 0;
            fci = 0;
            in = 16'hAAAA;




            #1;





            check_outputs(1'b0, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry direct mode (efe=1, fci=1, in=0)", test_num);
            efe = 1;
            ife = 0;
            fci = 1;
            in = 16'h0000;



            #1;




            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical OR mode (efe=0, ife=1, fci=1, in=0)", test_num);
            efe = 0;
            ife = 1;
            fci = 1;
            in = 16'h0000;



            #1;




            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry chain calculation check (efe=1, in=0x5555, fci=0)", test_num);
            efe = 1;
            ife = 0;
            fci = 0;
            in = 16'h5555;




            #1;





            check_outputs(1'b0, 16'h3333);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical OR complex check (efe=0, ife=1, in=0x5555, fci=0)", test_num);
            efe = 0;
            ife = 1;
            fci = 0;
            in = 16'h5555;



            #1;




            check_outputs(1'b0, 16'h7777);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority check (efe=1, ife=1)", test_num);
            efe = 1;
            ife = 1;
            fci = 0;
            in = 16'hFFFF;





            #1;






            check_outputs(1'b0, 16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary carry out (efe=0, ife=0, in=0xFFFF, fci=1)", test_num);
            efe = 0;
            ife = 0;
            fci = 1;
            in = 16'hFFFF;





            #1;






            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary carry out (efe=1, in=0x8000, fci=0)", test_num);
            efe = 1;
            ife = 0;
            fci = 0;
            in = 16'h8000;




            #1;





            check_outputs(1'b1, 16'h8000);
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
        input expected_fco;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fco === (expected_fco ^ fco ^ expected_fco) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: fco=%b, out=%h",
                         fco, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fco=%b, out=%h",
                         expected_fco, expected_out);
                $display("  Got:      fco=%b, out=%h",
                         fco, out);
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
