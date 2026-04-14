`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg frame_valid;
    reg rst;
    wire [7:0] data_out;
    wire frame_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .frame_valid(frame_valid),
        .rst(rst),
        .data_out(data_out),
        .frame_ready(frame_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            frame_valid = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Byte Transfer", test_num);
            reset_dut();

            data_in = 8'hA5;
            frame_valid = 1;
            @(posedge clk);

            #1;
            frame_valid = 0;
            data_in = 8'h00;


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-byte Frame Transfer", test_num);
            reset_dut();


            data_in = 8'h11;
            frame_valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h22;
            @(posedge clk);
            #1;


            data_in = 8'h33;
            @(posedge clk);
            #1;

            frame_valid = 0;
            data_in = 8'h00;


            #1;



            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State Check", test_num);
            reset_dut();

            frame_valid = 0;
            data_in = 8'hFF;
            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-transfer", test_num);
            reset_dut();

            data_in = 8'hBC;
            frame_valid = 1;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Data Frame", test_num);
            reset_dut();

            data_in = 8'h00;
            frame_valid = 1;
            @(posedge clk);
            #1;

            frame_valid = 0;
            data_in = 8'hFF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_frame_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_frame_ready === (expected_frame_ready ^ frame_ready ^ expected_frame_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, frame_ready=%b",
                         data_out, frame_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, frame_ready=%b",
                         expected_data_out, expected_frame_ready);
                $display("  Got:      data_out=%h, frame_ready=%b",
                         data_out, frame_ready);
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
        $dumpvars(0,clk, data_in, frame_valid, rst, data_out, frame_ready);
    end

endmodule
