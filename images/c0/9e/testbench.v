`timescale 1ns/1ps

module shift_rows_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    wire [127:0] data_out_dec;
    wire [127:0] data_out_enc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_rows dut (
        .data_in(data_in),
        .data_out_dec(data_out_dec),
        .data_out_enc(data_out_enc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            data_in = 128'h0;
            #1;

            check_outputs(128'h0, 128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Linear Sequence 00-0F", test_num);
            data_in = 128'h000102030405060708090a0b0c0d0e0f;













            #1;














            check_outputs(128'h000d0a0704010e0b0805020f0c090603, 128'h00050a0f04090e03080d02070c01060b);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Inverse Property Check", test_num);
            data_in = 128'h00050a0f04090e03080d02070c01060b;
            #1;
            if (data_out_dec === 128'h000102030405060708090a0b0c0d0e0f) begin
                $display("PASS: Dec(Enc(M)) == M");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Dec(Enc(M)) mismatch. Got %h", data_out_dec);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Standard AES State Example", test_num);
            data_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5;

            #1;


            check_outputs(128'hd42711ae_e05df127_b8b49830_1e4152e5, 128'hd4e0b81ebfb441275d52119830aef1e5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_rows Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [127:0] expected_data_out_dec;
        input [127:0] expected_data_out_enc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out_dec === (expected_data_out_dec ^ data_out_dec ^ expected_data_out_dec) &&
                expected_data_out_enc === (expected_data_out_enc ^ data_out_enc ^ expected_data_out_enc)) begin
                $display("PASS");
                $display("  Outputs: data_out_dec=%h, data_out_enc=%h",
                         data_out_dec, data_out_enc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_dec=%h, data_out_enc=%h",
                         expected_data_out_dec, expected_data_out_enc);
                $display("  Got:      data_out_dec=%h, data_out_enc=%h",
                         data_out_dec, data_out_enc);
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
