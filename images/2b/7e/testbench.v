`timescale 1ns/1ps

module DES_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [55:0] key;
    reg mode;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES dut (
        .data_in(data_in),
        .key(key),
        .mode(mode),
        .data_out(data_out)
    );
    task testcase001;

        reg [7:0] original_data;
        reg [7:0] cipher_text;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Encrypt and Decrypt Round-trip (Data: 8'hA5)", test_num);


            original_data = 8'hA5;
            key = 56'h123456789ABCDE;
            mode = 1'b0;
            data_in = original_data;
            #10;
            cipher_text = data_out;


            mode = 1'b1;
            data_in = cipher_text;
            #10;


            #1;



            check_outputs(original_data);
        end
        endtask

    task testcase002;

        reg [7:0] original_data;
        reg [7:0] cipher_text;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Test", test_num);

            original_data = 8'h00;
            key = 56'h00000000000000;
            mode = 1'b0;
            data_in = original_data;
            #10;
            cipher_text = data_out;

            mode = 1'b1;
            data_in = cipher_text;
            #10;

            #1;


            check_outputs(original_data);
        end
        endtask

    task testcase003;

        reg [7:0] original_data;
        reg [7:0] cipher_text;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Test", test_num);

            original_data = 8'hFF;
            key = 56'hFFFFFFFFFFFFFF;
            mode = 1'b0;
            data_in = original_data;
            #10;
            cipher_text = data_out;

            mode = 1'b1;
            data_in = cipher_text;
            #10;

            #1;


            check_outputs(original_data);
        end
        endtask

    task testcase004;

        reg [7:0] cipher1;
        reg [7:0] cipher2;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Sensitivity (Same data, different keys)", test_num);

            data_in = 8'h3C;
            mode = 1'b0;

            key = 56'hAAAAAAAAAAAAAAAAAAAAAA;
            #10;
            cipher1 = data_out;

            key = 56'hBBBBBBBBBBBBBBBBBBBBBB;
            #10;
            cipher2 = data_out;


            if (cipher1 !== cipher2) begin
                $display("PASS: Key variation changed output");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Different keys produced identical output");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [7:0] original_data;
        reg [7:0] cipher_text;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern", test_num);

            original_data = 8'hAA;
            key = 56'hFEDCBA98765432;
            mode = 1'b0;
            data_in = original_data;
            #10;
            cipher_text = data_out;

            mode = 1'b1;
            data_in = cipher_text;
            #10;

            #1;


            check_outputs(original_data);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data_out;
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
