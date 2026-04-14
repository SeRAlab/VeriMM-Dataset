`timescale 1ns/1ps

module unsigned_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    unsigned_multiplier dut (
        .a(a),
        .b(b),
        .p(p)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplication (0 * 0)", test_num);
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero multiplication (255 * 0)", test_num);
            a = 8'd255;
            b = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity multiplication (1 * 123)", test_num);
            a = 8'd1;
            b = 8'd123;
            #1;

            check_outputs(16'd123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity multiplication (200 * 1)", test_num);
            a = 8'd200;
            b = 8'd1;
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small values (5 * 4)", test_num);
            a = 8'd5;
            b = 8'd4;
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (255 * 255)", test_num);
            a = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Powers of two (16 * 8)", test_num);
            a = 8'd16;
            b = 8'd8;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime numbers (13 * 17)", test_num);
            a = 8'd13;
            b = 8'd17;
            #1;

            check_outputs(16'd221);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large result (128 * 128)", test_num);
            a = 8'd128;
            b = 8'd128;
            #1;

            check_outputs(16'd16384);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random values (123 * 45)", test_num);
            a = 8'd123;
            b = 8'd45;
            #1;

            check_outputs(16'd5535);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("unsigned_multiplier Testbench");
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
        input [15:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
