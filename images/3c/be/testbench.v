`timescale 1ns/1ps

module DES_round_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [7:0] key;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Zeros", test_num);
        data_in = 8'h00;
        key     = 8'h00;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Ones", test_num);
        data_in = 8'hFF;
        key     = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Zeros Data, All Ones Key", test_num);
        data_in = 8'h00;
        key     = 8'hFF;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Ones Data, All Zeros Key", test_num);
        data_in = 8'hFF;
        key     = 8'h00;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Checkerboard Pattern 0xAA", test_num);
        data_in = 8'hAA;
        key     = 8'h55;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Checkerboard Pattern 0x55", test_num);
        data_in = 8'h55;
        key     = 8'hAA;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Bit Set (MSB)", test_num);
        data_in = 8'h80;
        key     = 8'h00;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: High Nibble Data, Low Nibble Key", test_num);
        data_in = 8'hF0;
        key     = 8'h0F;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Random Mix 1", test_num);
        data_in = 8'h3C;
        key     = 8'hA1;
        #1;

        check_outputs(8'hBD);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Bit Set (LSB)", test_num);
        data_in = 8'h01;
        key     = 8'hFE;
        #1;

        check_outputs(8'h10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_round Testbench");
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
