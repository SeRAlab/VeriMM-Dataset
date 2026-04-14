`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frame_data;
    reg [7:0] frame_length;
    reg frame_valid;
    reg rst;
    wire [7:0] received_data;
    wire valid_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_length(frame_length),
        .frame_valid(frame_valid),
        .rst(rst),
        .received_data(received_data),
        .valid_frame(valid_frame)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            frame_data = 8'h0;
            frame_length = 8'h0;
            frame_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid 4-byte frame", test_num);
            reset_dut();


            frame_length = 8'd4;


            for (i = 0; i < 4; i = i + 1) begin
                frame_valid = 1;
                frame_data = 8'h10 + i;
                @(posedge clk);
            end


            frame_valid = 0;
            frame_data = 8'h00;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h13, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Short frame (Invalid)", test_num);
            reset_dut();

            frame_length = 8'd6;


            for (i = 0; i < 3; i = i + 1) begin
                frame_valid = 1;
                frame_data = 8'hA0 + i;
                @(posedge clk);
            end

            frame_valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hA2, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Long frame (Invalid)", test_num);
            reset_dut();

            frame_length = 8'd2;


            for (i = 0; i < 5; i = i + 1) begin
                frame_valid = 1;
                frame_data = 8'hC0 + i;
                @(posedge clk);
            end

            frame_valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hC4, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum valid 1-byte frame", test_num);
            reset_dut();

            frame_length = 8'd1;

            frame_valid = 1;
            frame_data = 8'hFF;
            @(posedge clk);

            frame_valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid 10-byte frame", test_num);
            reset_dut();

            frame_length = 8'd10;

            for (i = 0; i < 10; i = i + 1) begin
                frame_valid = 1;
                frame_data = i;
                @(posedge clk);
            end

            frame_valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd9, 1'b1);
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
        input [7:0] expected_received_data;
        input expected_valid_frame;
        begin
            if (expected_received_data === (expected_received_data ^ received_data ^ expected_received_data) &&
                expected_valid_frame === (expected_valid_frame ^ valid_frame ^ expected_valid_frame)) begin
                $display("PASS");
                $display("  Outputs: received_data=%h, valid_frame=%b",
                         received_data, valid_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: received_data=%h, valid_frame=%b",
                         expected_received_data, expected_valid_frame);
                $display("  Got:      received_data=%h, valid_frame=%b",
                         received_data, valid_frame);
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
        $dumpvars(0,clk, frame_data, frame_length, frame_valid, rst, received_data, valid_frame);
    end

endmodule
