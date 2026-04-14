`timescale 1ns/1ps

module multiplexer_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg [1:0] select;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplexer_4to1 dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Selecting data_in0", test_num);
            data_in0 = 8'hAA;
            data_in1 = 8'h00;
            data_in2 = 8'h00;
            data_in3 = 8'h00;
            select   = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Selecting data_in1", test_num);
            data_in0 = 8'h00;
            data_in1 = 8'hBB;
            data_in2 = 8'h00;
            data_in3 = 8'h00;
            select   = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Selecting data_in2", test_num);
            data_in0 = 8'h00;
            data_in1 = 8'h00;
            data_in2 = 8'hCC;
            data_in3 = 8'h00;
            select   = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Selecting data_in3", test_num);
            data_in0 = 8'h00;
            data_in1 = 8'h00;
            data_in2 = 8'h00;
            data_in3 = 8'hDD;
            select   = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Data Integrity (unselected inputs changing)", test_num);
            select   = 2'b01;
            data_in0 = 8'hFF;
            data_in1 = 8'h55;
            data_in2 = 8'hAA;
            data_in3 = 8'hEE;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Cycling through all select states with unique data", test_num);
            data_in0 = 8'h01;
            data_in1 = 8'h02;
            data_in2 = 8'h04;
            data_in3 = 8'h08;

            select = 2'b00; #1;
            select = 2'b01; #1;
            select = 2'b10; #1;
            select = 2'b11;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: All inputs 0xFF", test_num);
            data_in0 = 8'hFF;
            data_in1 = 8'hFF;
            data_in2 = 8'hFF;
            data_in3 = 8'hFF;
            select   = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Rapid select switching", test_num);
            data_in0 = 8'h10;
            data_in1 = 8'h20;
            data_in2 = 8'h30;
            data_in3 = 8'h40;

            select = 2'b11; #1;
            select = 2'b00;
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
        $display("multiplexer_4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
