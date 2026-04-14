`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] code;
    reg [24:0] mcand;
    wire [25:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .code(code),
        .mcand(mcand),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=000, mcand=0x1234567 (Expected: 0)", test_num);
        code = 3'b000; mcand = 25'h1234567;
        #1;

        check_outputs(26'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=001, mcand=5 (Expected: 5)", test_num);
        code = 3'b001; mcand = 25'h5;
        #1;

        check_outputs(26'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=010, mcand=-5 (Expected: -5)", test_num);
        code = 3'b010; mcand = 25'h1FFFFFB;
        #1;

        check_outputs(26'h3FFFFFFB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=011, mcand=10 (Expected: 20)", test_num);
        code = 3'b011; mcand = 25'hA;
        #1;

        check_outputs(26'h14);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=011, mcand=-10 (Expected: -20)", test_num);
        code = 3'b011; mcand = 25'h1FFFFF6;
        #1;

        check_outputs(26'h3FFFFEC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=100, mcand=3 (Expected: -6)", test_num);
        code = 3'b100; mcand = 25'h3;
        #1;

        check_outputs(26'h3FFFFFA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=100, mcand=-3 (Expected: 6)", test_num);
        code = 3'b100; mcand = 25'h1FFFFFD;
        #1;

        check_outputs(26'h6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=101, mcand=7 (Expected: -7)", test_num);
        code = 3'b101; mcand = 25'h7;
        #1;

        check_outputs(26'h3FFFFF9);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=110, mcand=-7 (Expected: 7)", test_num);
        code = 3'b110; mcand = 25'h1FFFFF9;
        #1;

        check_outputs(26'h7);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: code=111, mcand=0xABCDEF (Expected: 0)", test_num);
        code = 3'b111; mcand = 25'h0ABCDEF;
        #1;

        check_outputs(26'h0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max positive +2M", test_num);
        code = 3'b011; mcand = 25'h0FFFFFF;
        #1;

        check_outputs(26'h1FFFFFE);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max negative +1M", test_num);
        code = 3'b001; mcand = 25'h1000000;
        #1;

        check_outputs(26'h3000000);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max negative -1M", test_num);
        code = 3'b101; mcand = 25'h1000000;
        #1;

        check_outputs(26'h1000000);
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
        testcase012();
        testcase013();
        
        
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
        input [25:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
