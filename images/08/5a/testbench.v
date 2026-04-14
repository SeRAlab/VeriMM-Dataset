`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg rst_n;
    wire [7:0] data_out;
    wire data_transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .rst_n(rst_n),
        .data_out(data_out),
        .data_transfer_done(data_transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            channel_select = 3'b000;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic transfer on Channel 0", test_num);
            reset_dut();

            channel_select = 3'b000;
            data_in = 8'hA5;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transfer on Channel 7", test_num);
            reset_dut();

            channel_select = 3'b111;
            data_in = 8'h5A;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify no transfer when enable=0", test_num);
            reset_dut();

            channel_select = 3'b011;
            data_in = 8'hFF;
            enable = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive transfers", test_num);
            reset_dut();


            channel_select = 3'b010;
            data_in = 8'h11;
            enable = 1;
            @(posedge clk);


            channel_select = 3'b100;
            data_in = 8'h22;
            enable = 1;
            @(posedge clk);

            #2;
            #1;

            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active transfer", test_num);
            reset_dut();

            channel_select = 3'b001;
            data_in = 8'hCC;
            enable = 1;

            @(posedge clk);
            #1 rst_n = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data integrity (walking ones)", test_num);
            reset_dut();

            channel_select = 3'b110;
            data_in = 8'b10101010;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'b10101010, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_data_transfer_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_transfer_done === (expected_data_transfer_done ^ data_transfer_done ^ expected_data_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_transfer_done=%b",
                         data_out, data_transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_transfer_done=%b",
                         expected_data_out, expected_data_transfer_done);
                $display("  Got:      data_out=%h, data_transfer_done=%b",
                         data_out, data_transfer_done);
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
        $dumpvars(0,channel_select, clk, data_in, enable, rst_n, data_out, data_transfer_done);
    end

endmodule
