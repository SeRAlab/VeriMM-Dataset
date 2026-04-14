`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_select;
    reg clk;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg [7:0] dest_addr_a;
    reg [7:0] dest_addr_b;
    reg rstn;
    reg [7:0] source_addr_a;
    reg [7:0] source_addr_b;
    reg start_transfer;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .dest_addr_a(dest_addr_a),
        .dest_addr_b(dest_addr_b),
        .rstn(rstn),
        .source_addr_a(source_addr_a),
        .source_addr_b(source_addr_b),
        .start_transfer(start_transfer),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            channel_select = 0;
            data_a = 0;
            data_b = 0;
            dest_addr_a = 0;
            dest_addr_b = 0;
            source_addr_a = 0;
            source_addr_b = 0;
            start_transfer = 0;
            #20;
            rstn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Channel A Transfer");
            test_num = 1;
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            source_addr_a = 8'h10;
            dest_addr_a = 8'h20;
            data_a = 8'hAA;
            start_transfer = 1;

            @(posedge clk);
            start_transfer = 0;


            repeat (10) begin
                if (transfer_complete) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Channel B Transfer");
            test_num = 2;
            reset_dut();

            @(posedge clk);
            channel_select = 1;
            source_addr_b = 8'h50;
            dest_addr_b = 8'h60;
            data_b = 8'hBB;
            start_transfer = 1;

            @(posedge clk);
            start_transfer = 0;


            repeat (10) begin
                if (transfer_complete) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: No Start Signal");
            test_num = 3;
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            source_addr_a = 8'h11;
            dest_addr_a = 8'h22;
            data_a = 8'hCC;
            start_transfer = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Sequential Ch A then Ch B");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            channel_select = 0;
            source_addr_a = 8'hA1;
            dest_addr_a = 8'hA2;
            data_a = 8'hA3;
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            repeat (10) begin
                if (transfer_complete) break;
                @(posedge clk);
            end


            @(posedge clk);
            channel_select = 1;
            source_addr_b = 8'hB1;
            dest_addr_b = 8'hB2;
            data_b = 8'hB3;
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;

            repeat (10) begin
                if (transfer_complete) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Reset during transfer");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            channel_select = 0;
            start_transfer = 1;
            @(posedge clk);


            rstn = 0;
            #15;
            rstn = 1;

            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0);
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
        input expected_transfer_complete;
        begin
            if (expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: transfer_complete=%b",
                         transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: transfer_complete=%b",
                         expected_transfer_complete);
                $display("  Got:      transfer_complete=%b",
                         transfer_complete);
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
        $dumpvars(0,channel_select, clk, data_a, data_b, dest_addr_a, dest_addr_b, rstn, source_addr_a, source_addr_b, start_transfer, transfer_complete);
    end

endmodule
