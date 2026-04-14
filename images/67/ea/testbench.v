`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] In1_0;
    reg [17:0] In1_1;
    reg [17:0] In1_2;
    wire [17:0] Out1_0;
    wire [17:0] Out1_1;
    wire [17:0] Out1_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1_0(In1_0),
        .In1_1(In1_1),
        .In1_2(In1_2),
        .Out1_0(Out1_0),
        .Out1_1(Out1_1),
        .Out1_2(Out1_2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            In1_0 = 18'h00000;
            In1_1 = 18'h00000;
            In1_2 = 18'h00000;
            #1;

            check_outputs(18'h00000, 18'h00000, 18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple positive values (even and odd)", test_num);
            In1_0 = 18'd2;
            In1_1 = 18'd10;
            In1_2 = 18'd101;
            #1;

            check_outputs(18'd1, 18'd5, 18'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple negative values (preserving sign)", test_num);



            In1_0 = 18'h3FFFE;
            In1_1 = 18'h3FFFC;
            In1_2 = 18'h3FFF6;
            #1;

            check_outputs(18'h3FFFF, 18'h3FFFE, 18'h3FFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative odd values", test_num);



            In1_0 = 18'h3FFFF;
            In1_1 = 18'h3FFFD;
            In1_2 = 18'h3FFFB;
            #1;

            check_outputs(18'h3FFFF, 18'h3FFFE, 18'h3FFFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum and Minimum range values", test_num);


            In1_0 = 18'h1FFFF;
            In1_1 = 18'h20000;
            In1_2 = 18'h00001;
            #1;

            check_outputs(18'h0FFFF, 18'h30000, 18'h00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);


            In1_0 = 18'h2AAAA;
            In1_1 = 18'h15555;
            In1_2 = 18'h00000;
            #1;

            check_outputs(18'h35555, 18'h0AAAA, 18'h00000);
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
        input [17:0] expected_Out1_0;
        input [17:0] expected_Out1_1;
        input [17:0] expected_Out1_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out1_0 === (expected_Out1_0 ^ Out1_0 ^ expected_Out1_0) &&
                expected_Out1_1 === (expected_Out1_1 ^ Out1_1 ^ expected_Out1_1) &&
                expected_Out1_2 === (expected_Out1_2 ^ Out1_2 ^ expected_Out1_2)) begin
                $display("PASS");
                $display("  Outputs: Out1_0=%h, Out1_1=%h, Out1_2=%h",
                         Out1_0, Out1_1, Out1_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out1_0=%h, Out1_1=%h, Out1_2=%h",
                         expected_Out1_0, expected_Out1_1, expected_Out1_2);
                $display("  Got:      Out1_0=%h, Out1_1=%h, Out1_2=%h",
                         Out1_0, Out1_1, Out1_2);
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
