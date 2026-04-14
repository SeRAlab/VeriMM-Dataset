`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] req;
    reg reset;
    wire [7:0] ack;
    wire [7:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .ack(ack),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Request Channel 0", test_num);
            reset_dut();
            req = 8'h01;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Single Request Channel 7", test_num);
            reset_dut();
            req = 8'h80;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h80, 8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Multiple Requests (0 and 1) - Initial Priority", test_num);
            reset_dut();
            req = 8'h03;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Round-Robin sequence (0 then 1)", test_num);
            reset_dut();

            req = 8'h03;
            @(posedge clk);

            wait(grant[0] == 1'b1);
            @(posedge clk);
            req = 8'h02;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Round-Robin Wrap-around (7 then 0)", test_num);
            reset_dut();

            req = 8'h80;
            @(posedge clk);
            wait(grant[7] == 1'b1);

            req = 8'h81;
            @(posedge clk);
            req = 8'h01;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h01, 8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_ack;
        input [7:0] expected_grant;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, grant=%h",
                         ack, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, grant=%h",
                         expected_ack, expected_grant);
                $display("  Got:      ack=%h, grant=%h",
                         ack, grant);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, req, reset, ack, grant);
    end

endmodule
