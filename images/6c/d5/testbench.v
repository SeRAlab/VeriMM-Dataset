`timescale 1ns/1ps

module encoder16to4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] bin;
    wire [3:0] enc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder16to4 dut (
        .bin(bin),
        .enc(enc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 0", test_num);
            bin = 16'h0001;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 1", test_num);
            bin = 16'h0002;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 2", test_num);
            bin = 16'h0004;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 3", test_num);
            bin = 16'h0008;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 4", test_num);
            bin = 16'h0010;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 5", test_num);
            bin = 16'h0020;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 6", test_num);
            bin = 16'h0040;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 7", test_num);
            bin = 16'h0080;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 8", test_num);
            bin = 16'h0100;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 9", test_num);
            bin = 16'h0200;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 10", test_num);
            bin = 16'h0400;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 11", test_num);
            bin = 16'h0800;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 12", test_num);
            bin = 16'h1000;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 13", test_num);
            bin = 16'h2000;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 14", test_num);
            bin = 16'h4000;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: bit 15", test_num);
            bin = 16'h8000;
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
        $display("encoder16to4 Testbench");
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
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_enc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enc === (expected_enc ^ enc ^ expected_enc)) begin
                $display("PASS");
                $display("  Outputs: enc=%h",
                         enc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enc=%h",
                         expected_enc);
                $display("  Got:      enc=%h",
                         enc);
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
