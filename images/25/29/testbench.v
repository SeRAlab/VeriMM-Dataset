`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dst_addr;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .dst_addr(dst_addr),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            ack = 0;
            data_in = 8'h00;
            src_addr = 8'h00;
            dst_addr = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Sequential Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h10;
            dst_addr = 8'h20;
            start = 1;
            @(posedge clk);
            start = 0;


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 8'h01;




                repeat(1) @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
            end



            #1;




            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_val;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Bit Pattern Transfer (AA/55)", test_num);
            reset_dut();

            src_addr = 8'hF0;
            dst_addr = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 8; i = i + 1) begin
                if (i % 2 == 0) test_val = 8'hAA;
                else           test_val = 8'h55;

                data_in = test_val;

                repeat(1) @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
            end


            #1;



            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Idle State Check", test_num);
            reset_dut();


            src_addr = 8'h00;
            dst_addr = 8'h10;
            start = 1;
            @(posedge clk);
            start = 0;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = 8'hFF;
                repeat(1) @(posedge clk);
                ack = 1;
                @(posedge clk);
                ack = 0;
            end


            repeat(5) @(posedge clk);




            #1;





            check_outputs(8'hFF, 1'b1);
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
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,ack, clk, data_in, dst_addr, src_addr, start, data_out, done);
    end

endmodule
