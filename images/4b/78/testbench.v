`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C0;
    reg [3:0] G;
    reg [3:0] P;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C0(C0),
        .G(G),
        .P(P),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        G = 4'b0000; P = 4'b0000; C0 = 1'b0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: C0=1 with no propagate signals", test_num);
        G = 4'b0000; P = 4'b0000; C0 = 1'b1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: C0=1 with all propagate signals set", test_num);
        G = 4'b0000; P = 4'b1111; C0 = 1'b1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Generate G[0] set", test_num);
        G = 4'b0001; P = 4'b0000; C0 = 1'b0;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Generate G[1] set", test_num);
        G = 4'b0010; P = 4'b0000; C0 = 1'b0;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Generate G[2] set", test_num);
        G = 4'b0100; P = 4'b0000; C0 = 1'b0;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Generate G[3] set", test_num);
        G = 4'b1000; P = 4'b0000; C0 = 1'b0;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Chain propagation from G[0] to C[1]", test_num);
        G = 4'b0001; P = 4'b0010; C0 = 1'b0;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Full propagation chain from G[0]", test_num);
        G = 4'b0001; P = 4'b1110; C0 = 1'b0;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed G and P signals pattern", test_num);
        G = 4'b1010; P = 4'b0101; C0 = 1'b0;




        #1;





        check_outputs(4'b1110);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All signals high", test_num);
        G = 4'b1111; P = 4'b1111; C0 = 1'b1;
        #1;

        check_outputs(4'b1111);
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
        testcase011();
        
        
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
