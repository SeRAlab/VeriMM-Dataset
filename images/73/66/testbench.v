`timescale 1ns/1ps

module decoder_4to16_with_enable_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16_with_enable dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Disabled State (enable=0, data_in=4'h0)", test_num);
            enable = 0;
            data_in = 4'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Disabled State (enable=0, data_in=4'hF)", test_num);
            enable = 0;
            data_in = 4'hF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enabled, data_in=4'h0", test_num);
            enable = 1;
            data_in = 4'h0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enabled, data_in=4'h1", test_num);
            enable = 1;
            data_in = 4'h1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Enabled, data_in=4'h4", test_num);
            enable = 1;
            data_in = 4'h4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Enabled, data_in=4'h7", test_num);
            enable = 1;
            data_in = 4'h7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Enabled, data_in=4'h8", test_num);
            enable = 1;
            data_in = 4'h8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Enabled, data_in=4'hA", test_num);
            enable = 1;
            data_in = 4'hA;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Enabled, data_in=4'hF", test_num);
            enable = 1;
            data_in = 4'hF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Transition Enabled to Disabled (data_in=4'h5)", test_num);
            enable = 1;
            data_in = 4'h5;
            #2;
            enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16_with_enable Testbench");
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
