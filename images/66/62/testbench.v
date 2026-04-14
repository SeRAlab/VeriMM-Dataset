`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] m;
    reg [3:0] n;
    reg [1:0] p;
    reg [3:0] q;
    wire [3:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .p(p),
        .q(q),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            m = 4'hA;
            n = 4'h5;
            p = 2'b00;
            q = 4'h7;
            $display("Test %0d: p=0 (Select q)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            m = 4'hA;
            n = 4'h5;
            p = 2'b01;
            q = 4'h7;
            $display("Test %0d: p=1 (Select n)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            m = 4'hA;
            n = 4'h5;
            p = 2'b10;
            q = 4'h7;
            $display("Test %0d: p=2 (Select m)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            m = 4'h2;
            n = 4'h3;
            p = 2'b11;
            q = 4'h0;
            $display("Test %0d: p=3 (Select m + n)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            m = 4'hF;
            n = 4'h2;
            p = 2'b11;
            q = 4'h0;
            $display("Test %0d: p=3 (Select m + n with overflow)", test_num);

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            m = 4'h0;
            n = 4'h0;
            p = 2'b11;
            q = 4'h0;
            $display("Test %0d: All inputs zero, p=3", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            m = 4'h3;
            n = 4'h4;
            q = 4'hE;

            p = 2'b00; #5;
            p = 2'b01; #5;
            p = 2'b10; #5;
            p = 2'b11;

            $display("Test %0d: Sequence check p=3", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            m = 4'h1;
            n = 4'h1;
            p = 2'b00;
            q = 4'hF;
            $display("Test %0d: p=0 (Select q=F)", test_num);
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
