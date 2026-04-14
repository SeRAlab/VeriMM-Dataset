`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire ack;
    wire [1:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .ack(ack),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Single request on Channel 0", test_num);
            req = 4'b0001;

            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Single request on Channel 2", test_num);
            req = 4'b0100;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous requests (Ch0 and Ch3) - Priority check", test_num);
            req = 4'b1001;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous requests (Ch1 and Ch2) - Priority check", test_num);
            req = 4'b0110;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: No requests - Controller should remain idle", test_num);
            req = 4'b0000;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, sel);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Single request on Channel 3", test_num);
            req = 4'b1000;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All channels requesting - Highest priority check", test_num);
            req = 4'b1111;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 2'b00);
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
        input expected_ack;
        input [1:0] expected_sel;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, sel=%h",
                         ack, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, sel=%h",
                         expected_ack, expected_sel);
                $display("  Got:      ack=%b, sel=%h",
                         ack, sel);
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
        $dumpvars(0,clk, req, rst, ack, sel);
    end

endmodule
