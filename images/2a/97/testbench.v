`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1519:0] frame_in;
    reg frame_valid;
    reg rst;
    wire [11:0] frame_length;
    wire valid_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_in(frame_in),
        .frame_valid(frame_valid),
        .rst(rst),
        .frame_length(frame_length),
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
            frame_in = 0;
            frame_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing minimum valid frame length (64 bytes)", test_num);
            reset_dut();


            frame_in = 1520'h40;
            frame_valid = 1;
            @(posedge clk);
            frame_valid = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd64, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing maximum valid frame length (1518 bytes)", test_num);
            reset_dut();

            frame_in = 1520'h5EE;
            frame_valid = 1;
            @(posedge clk);
            frame_valid = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd1518, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing undersized frame (32 bytes)", test_num);
            reset_dut();

            frame_in = 1520'h20;
            frame_valid = 1;
            @(posedge clk);
            frame_valid = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd32, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing oversized frame (1600 bytes)", test_num);
            reset_dut();

            frame_in = 1520'h640;
            frame_valid = 1;
            @(posedge clk);
            frame_valid = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd1600, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing typical valid frame length (512 bytes)", test_num);
            reset_dut();

            frame_in = 1520'h200;
            frame_valid = 1;
            @(posedge clk);
            frame_valid = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(12'd512, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing reset state", test_num);
            reset_dut();


            #1;



            check_outputs(12'd0, 1'b0);
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
        input [11:0] expected_frame_length;
        input expected_valid_frame;
        begin
            if (expected_frame_length === (expected_frame_length ^ frame_length ^ expected_frame_length) &&
                expected_valid_frame === (expected_valid_frame ^ valid_frame ^ expected_valid_frame)) begin
                $display("PASS");
                $display("  Outputs: frame_length=%h, valid_frame=%b",
                         frame_length, valid_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_length=%h, valid_frame=%b",
                         expected_frame_length, expected_valid_frame);
                $display("  Got:      frame_length=%h, valid_frame=%b",
                         frame_length, valid_frame);
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
        $dumpvars(0,clk, frame_in, frame_valid, rst, frame_length, valid_frame);
    end

endmodule
