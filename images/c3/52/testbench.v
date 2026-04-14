`timescale 1ns/1ps

module BrzSlice_1_18_16_tb;

    // Testbench signals (combinational circuit)
    reg inp_0a;
    reg [17:0] inp_0d;
    reg out_0r;
    wire inp_0r;
    wire out_0a;
    wire out_0d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BrzSlice_1_18_16 dut (
        .inp_0a(inp_0a),
        .inp_0d(inp_0d),
        .out_0r(out_0r),
        .inp_0r(inp_0r),
        .out_0a(out_0a),
        .out_0d(out_0d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zeroed", test_num);
        out_0r = 1'b0;
        inp_0a = 1'b0;
        inp_0d = 18'b0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Test out_0r to inp_0r loopback", test_num);
        out_0r = 1'b1;
        inp_0a = 1'b0;
        inp_0d = 18'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Test inp_0a to out_0a loopback", test_num);
        out_0r = 1'b0;
        inp_0a = 1'b1;
        inp_0d = 18'b0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Extraction of 17th bit (index 16) - High", test_num);
        out_0r = 1'b0;
        inp_0a = 1'b0;
        inp_0d = 18'h10000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Extraction of 17th bit (index 16) - Low with neighbors set", test_num);
        out_0r = 1'b0;
        inp_0a = 1'b0;

        inp_0d = 18'h27FFF;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs high", test_num);
        out_0r = 1'b1;
        inp_0a = 1'b1;
        inp_0d = 18'h3FFFF;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signal Independence Check", test_num);
        out_0r = 1'b1;
        inp_0a = 1'b0;
        inp_0d = 18'h10000;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BrzSlice_1_18_16 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_inp_0r;
        input expected_out_0a;
        input expected_out_0d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inp_0r === (expected_inp_0r ^ inp_0r ^ expected_inp_0r) &&
                expected_out_0a === (expected_out_0a ^ out_0a ^ expected_out_0a) &&
                expected_out_0d === (expected_out_0d ^ out_0d ^ expected_out_0d)) begin
                $display("PASS");
                $display("  Outputs: inp_0r=%b, out_0a=%b, out_0d=%b",
                         inp_0r, out_0a, out_0d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inp_0r=%b, out_0a=%b, out_0d=%b",
                         expected_inp_0r, expected_out_0a, expected_out_0d);
                $display("  Got:      inp_0r=%b, out_0a=%b, out_0d=%b",
                         inp_0r, out_0a, out_0d);
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
