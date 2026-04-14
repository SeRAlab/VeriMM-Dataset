`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable(enable),
        .req(req),
        .rst(rst),
        .ack(ack),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            req = 4'b0000;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 0 Request", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            req = 4'b0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 3 Request", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            req = 4'b1000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1000, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable Signal Gating", test_num);
            reset_dut();
            @(posedge clk);
            enable = 0;
            req = 4'b0010;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Priority Resolution (Ch 1 vs Ch 2)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            req = 4'b0110;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0010, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Transition to WAIT State", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            req = 4'b0100;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0100, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Return to IDLE after Completion", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            req = 4'b0001;
            @(posedge clk);
            @(posedge clk);
            req = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000, 2'b00);
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
        input [3:0] expected_ack;
        input [1:0] expected_state;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, state=%h",
                         ack, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, state=%h",
                         expected_ack, expected_state);
                $display("  Got:      ack=%h, state=%h",
                         ack, state);
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
        $dumpvars(0,clk, enable, req, rst, ack, state);
    end

endmodule
