`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            channel_select = 3'b000;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Channel 0 transfer", test_num);
            reset_dut();

            channel_select = 3'd0;
            enable = 1;


            repeat(20) begin
                if (transfer_done) break;
                @(posedge clk);
            end


            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Channel 7 transfer", test_num);
            reset_dut();

            channel_select = 3'd7;
            enable = 1;

            repeat(20) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Channel 4 transfer", test_num);
            reset_dut();

            channel_select = 3'd4;
            enable = 1;

            repeat(20) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify no transfer when enable is 0", test_num);
            reset_dut();

            channel_select = 3'd2;
            enable = 0;


            repeat(10) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Channel 3 transfer after reset", test_num);
            reset_dut();

            channel_select = 3'd3;
            enable = 1;

            repeat(20) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_transfer_done;
        begin
            if (expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: transfer_done=%b",
                         transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_done=%b",
                         expected_transfer_done);
                $display("  Got:      transfer_done=%b",
                         transfer_done);
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
        $dumpvars(0,channel_select, clk, enable, transfer_done);
    end

endmodule
