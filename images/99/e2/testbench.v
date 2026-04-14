`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ch0;
    reg [7:0] ch1;
    reg [7:0] ch2;
    reg [7:0] ch3;
    reg [1:0] channel;
    wire [7:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ch0(ch0),
        .ch1(ch1),
        .ch2(ch2),
        .ch3(ch3),
        .channel(channel),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select ch0", test_num);
            ch0 = 8'hA5;
            ch1 = 8'h5A;
            ch2 = 8'hFF;
            ch3 = 8'h00;
            channel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select ch1", test_num);
            ch0 = 8'h11;
            ch1 = 8'h22;
            ch2 = 8'h33;
            ch3 = 8'h44;
            channel = 2'b01;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select ch2", test_num);
            ch0 = 8'hDE;
            ch1 = 8'hAD;
            ch2 = 8'hBE;
            ch3 = 8'hEF;
            channel = 2'b10;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select ch3", test_num);
            ch0 = 8'h01;
            ch1 = 8'h02;
            ch2 = 8'h04;
            ch3 = 8'h08;
            channel = 2'b11;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Change data inputs while channel is fixed (ch2)", test_num);
            ch0 = 8'h00;
            ch1 = 8'h00;
            ch2 = 8'hAA;
            ch3 = 8'h00;
            channel = 2'b10;
            #5;
            ch2 = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Boundary values (All FFs)", test_num);
            ch0 = 8'hFF;
            ch1 = 8'hFF;
            ch2 = 8'hFF;
            ch3 = 8'hFF;
            channel = 2'b00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Invalid channel value (X/Z handling)", test_num);
            ch0 = 8'h12;
            ch1 = 8'h34;
            ch2 = 8'h56;
            ch3 = 8'h78;
            channel = 2'bxx;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
