`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ETH_CLK_OBUF;
    reg IN1_ACK;
    reg INTERNAL_RST_reg;
    reg [7:0] OUT1;
    reg OUT1_STB;
    wire IN1_STB;
    wire OUT1_ACK;
    wire [7:0] output_rs232_tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ETH_CLK_OBUF(ETH_CLK_OBUF),
        .IN1_ACK(IN1_ACK),
        .INTERNAL_RST_reg(INTERNAL_RST_reg),
        .OUT1(OUT1),
        .OUT1_STB(OUT1_STB),
        .IN1_STB(IN1_STB),
        .OUT1_ACK(OUT1_ACK),
        .output_rs232_tx(output_rs232_tx)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Module behavior during reset", test_num);


            INTERNAL_RST_reg = 1;
            OUT1 = 8'h55;
            OUT1_STB = 1;
            IN1_ACK = 1;

            repeat(2) @(posedge ETH_CLK_OBUF);


            #1;



            check_outputs(1'b1, 1'b0, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal transmission (No Ack)", test_num);


            INTERNAL_RST_reg = 1;
            #10;
            INTERNAL_RST_reg = 0;


            OUT1 = 8'hAA;
            OUT1_STB = 1;
            IN1_ACK = 0;

            repeat(2) @(posedge ETH_CLK_OBUF);


            #1;



            check_outputs(1'b1, 1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Successful acknowledgment signaling", test_num);


            INTERNAL_RST_reg = 1;
            #10;
            INTERNAL_RST_reg = 0;


            OUT1 = 8'h33;
            OUT1_STB = 1;
            IN1_ACK = 1;

            repeat(2) @(posedge ETH_CLK_OBUF);


            #1;



            check_outputs(1'b1, 1'b1, 8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asynchronous data passthrough change", test_num);


            INTERNAL_RST_reg = 1;
            #10;
            INTERNAL_RST_reg = 0;


            OUT1 = 8'hFF;
            OUT1_STB = 0;
            IN1_ACK = 1;

            repeat(2) @(posedge ETH_CLK_OBUF);


            #1;



            check_outputs(1'b0, 1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset overriding active acknowledgment", test_num);


            INTERNAL_RST_reg = 0;
            OUT1 = 8'hC0;
            OUT1_STB = 1;
            IN1_ACK = 1;
            repeat(2) @(posedge ETH_CLK_OBUF);


            INTERNAL_RST_reg = 1;
            repeat(2) @(posedge ETH_CLK_OBUF);


            #1;



            check_outputs(1'b1, 1'b0, 8'hC0);
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
        input expected_IN1_STB;
        input expected_OUT1_ACK;
        input [7:0] expected_output_rs232_tx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IN1_STB === (expected_IN1_STB ^ IN1_STB ^ expected_IN1_STB) &&
                expected_OUT1_ACK === (expected_OUT1_ACK ^ OUT1_ACK ^ expected_OUT1_ACK) &&
                expected_output_rs232_tx === (expected_output_rs232_tx ^ output_rs232_tx ^ expected_output_rs232_tx)) begin
                $display("PASS");
                $display("  Outputs: IN1_STB=%b, OUT1_ACK=%b, output_rs232_tx=%h",
                         IN1_STB, OUT1_ACK, output_rs232_tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IN1_STB=%b, OUT1_ACK=%b, output_rs232_tx=%h",
                         expected_IN1_STB, expected_OUT1_ACK, expected_output_rs232_tx);
                $display("  Got:      IN1_STB=%b, OUT1_ACK=%b, output_rs232_tx=%h",
                         IN1_STB, OUT1_ACK, output_rs232_tx);
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
