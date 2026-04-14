`timescale 1ns/1ps

module unsigned_min_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    unsigned_min dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .min(min)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            a = 32'd0; b = 32'd0; c = 32'd0; d = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs max value", test_num);
            a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; c = 32'hFFFFFFFF; d = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 'a' is minimum", test_num);
            a = 32'd10; b = 32'd50; c = 32'd100; d = 32'd1000;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 'b' is minimum", test_num);
            a = 32'd500; b = 32'd25; c = 32'd50; d = 32'd75;
            #1;

            check_outputs(32'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 'c' is minimum", test_num);
            a = 32'hA0000000; b = 32'hB0000000; c = 32'h12345678; d = 32'hC0000000;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 'd' is minimum", test_num);
            a = 32'd999; b = 32'd888; c = 32'd777; d = 32'd666;
            #1;

            check_outputs(32'd666);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple identical minimums (a and c)", test_num);
            a = 32'd42; b = 32'd100; c = 32'd42; d = 32'd200;
            #1;

            check_outputs(32'd42);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three identical minimums (a, b, d)", test_num);
            a = 32'd5; b = 32'd5; c = 32'd500; d = 32'd5;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Close values", test_num);
            a = 32'd1000001; b = 32'd1000000; c = 32'd1000002; d = 32'd1000003;
            #1;

            check_outputs(32'd1000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large range", test_num);
            a = 32'hFFFFFFFF; b = 32'h00000001; c = 32'h7FFFFFFF; d = 32'h0000FFFF;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("unsigned_min Testbench");
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
        input [31:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: min=%h",
                         min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h",
                         expected_min);
                $display("  Got:      min=%h",
                         min);
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
