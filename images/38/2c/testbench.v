`timescale 1ns/1ps

module rsa_keygen_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] p;
    reg [15:0] q;
    wire [31:0] d;
    wire [15:0] e;
    wire [31:0] n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_keygen dut (
        .p(p),
        .q(q),
        .d(d),
        .e(e),
        .n(n)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=151, q=157", test_num);
            p = 16'd151;
            q = 16'd157;

            #1;


            check_outputs(32'd21473, 16'h0001, 32'd23707);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=257, q=263", test_num);
            p = 16'd257;
            q = 16'd263;

            #1;


            check_outputs(32'd63489, 16'h0001, 32'd67591);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=17, q=19", test_num);
            p = 16'd17;
            q = 16'd19;

            #1;


            check_outputs(32'd161, 16'h0001, 32'd323);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=61, q=53", test_num);
            p = 16'd61;
            q = 16'd53;

            #1;


            check_outputs(32'd2753, 16'h0001, 32'd3233);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=137, q=139", test_num);
            p = 16'd137;
            q = 16'd139;

            #1;


            check_outputs(32'd6401, 16'h0001, 32'd19043);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: p=11, q=13", test_num);
            p = 16'd11;
            q = 16'd13;

            #1;


            check_outputs(32'd113, 16'h0001, 32'd143);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_keygen Testbench");
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
        input [31:0] expected_d;
        input [15:0] expected_e;
        input [31:0] expected_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: d=%h, e=%h, n=%h",
                         d, e, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h, e=%h, n=%h",
                         expected_d, expected_e, expected_n);
                $display("  Got:      d=%h, e=%h, n=%h",
                         d, e, n);
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
