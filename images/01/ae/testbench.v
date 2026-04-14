`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg read_data;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .read_data(read_data),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
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
            src_addr = 8'h0;
            dest_addr = 8'h0;
            read_data = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Transfer 0x55", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            read_data = 8'h55;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            fork : wait_complete
                begin
                    wait(transfer_complete == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable wait_complete;


            #1;



            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Transfer 0xAA with different addresses", test_num);
            reset_dut();

            src_addr = 8'hF0;
            dest_addr = 8'h0F;
            read_data = 8'hAA;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            fork : wait_complete
                begin
                    wait(transfer_complete == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable wait_complete;

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Idle state check (no start)", test_num);
            reset_dut();

            src_addr = 8'hA5;
            dest_addr = 8'h5A;
            read_data = 8'hFF;


            repeat(5) @(posedge clk);



            #1;




            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Transfer zero data", test_num);
            reset_dut();

            src_addr = 8'h01;
            dest_addr = 8'h02;
            read_data = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            fork : wait_complete
                begin
                    wait(transfer_complete == 1);
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable wait_complete;

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Reset mid-transfer", test_num);
            reset_dut();

            src_addr = 8'hCC;
            dest_addr = 8'hDD;
            read_data = 8'h77;

            @(posedge clk);
            start = 1;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(data_out, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_transfer_complete;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b",
                         expected_data_out, expected_transfer_complete);
                $display("  Got:      data_out=%h, transfer_complete=%b",
                         data_out, transfer_complete);
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
        $dumpvars(0,clk, dest_addr, read_data, reset, src_addr, start, data_out, transfer_complete);
    end

endmodule
