`timescale 1ns/1ps

module decoder_6to64_with_enable_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] data_in;
    reg enable;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_6to64_with_enable dut (
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Disabled check (Input 0)", test_num);
            enable = 0;
            data_in = 6'd0;
            #10;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Disabled check (Input 63)", test_num);
            enable = 0;
            data_in = 6'd63;
            #10;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enabled - Decode 0", test_num);
            enable = 1;
            data_in = 6'd0;
            #10;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enabled - Decode 1", test_num);
            enable = 1;
            data_in = 6'd1;
            #10;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enabled - Decode 31", test_num);
            enable = 1;
            data_in = 6'd31;
            #10;
            #1;

            check_outputs(64'h0000000080000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enabled - Decode 32", test_num);
            enable = 1;
            data_in = 6'd32;
            #10;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Enabled - Decode 63", test_num);
            enable = 1;
            data_in = 6'd63;
            #10;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Dynamic Input Transition (10 to 11)", test_num);
            enable = 1;
            data_in = 6'd10;
            #5;
            data_in = 6'd11;
            #10;
            #1;

            check_outputs(64'h0000000000000800);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Dynamic Enable Toggle (On to Off)", test_num);
            enable = 1;
            data_in = 6'd5;
            #5;
            enable = 0;
            #10;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Enabled - Decode 16", test_num);
            enable = 1;
            data_in = 6'd16;
            #10;
            #1;

            check_outputs(64'h0000000000010000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_6to64_with_enable Testbench");
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
        input [63:0] expected_data_out;
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
