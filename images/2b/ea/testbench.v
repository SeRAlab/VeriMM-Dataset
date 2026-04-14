`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bytes_to_transfer;
    reg clk;
    reg [7:0] destination_address;
    reg reset;
    reg [7:0] source_address;
    reg start;
    wire [7:0] current_address;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .bytes_to_transfer(bytes_to_transfer),
        .clk(clk),
        .destination_address(destination_address),
        .reset(reset),
        .source_address(source_address),
        .start(start),
        .current_address(current_address),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            source_address = 0;
            destination_address = 0;
            bytes_to_transfer = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic 10-byte transfer", test_num);
            reset_dut();

            source_address = 8'h10;
            destination_address = 8'h40;
            bytes_to_transfer = 8'd10;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!transfer_complete) begin
                @(posedge clk);
            end



            #1;




            check_outputs(8'h4A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single byte transfer", test_num);
            reset_dut();

            source_address = 8'hAA;
            destination_address = 8'hBB;
            bytes_to_transfer = 8'd1;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!transfer_complete) begin
                @(posedge clk);
            end

            #1;


            check_outputs(8'hBC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large transfer (255 bytes)", test_num);
            reset_dut();

            source_address = 8'h00;
            destination_address = 8'h00;
            bytes_to_transfer = 8'd255;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!transfer_complete) begin
                @(posedge clk);
            end


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during operation", test_num);
            reset_dut();

            source_address = 8'h00;
            destination_address = 8'h80;
            bytes_to_transfer = 8'd50;

            @(posedge clk);
            start = 1;
            repeat (5) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero byte transfer", test_num);
            reset_dut();

            source_address = 8'h10;
            destination_address = 8'h20;
            bytes_to_transfer = 8'd0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);

            if (transfer_complete)
                #1;

                check_outputs(8'h20, 1'b1);
            else
                #1;

                check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_current_address;
        input expected_transfer_complete;
        begin
            if (expected_current_address === (expected_current_address ^ current_address ^ expected_current_address) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: current_address=%h, transfer_complete=%b",
                         current_address, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_address=%h, transfer_complete=%b",
                         expected_current_address, expected_transfer_complete);
                $display("  Got:      current_address=%h, transfer_complete=%b",
                         current_address, transfer_complete);
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
        $dumpvars(0,bytes_to_transfer, clk, destination_address, reset, source_address, start, current_address, transfer_complete);
    end

endmodule
