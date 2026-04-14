`timescale 1ns/1ps

module eth_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] frame_in;
    reg frame_valid;
    reg rst_n;
    wire [63:0] frame_out;
    wire [1:0] frame_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_mac_controller dut (
        .clk(clk),
        .frame_in(frame_in),
        .frame_valid(frame_valid),
        .rst_n(rst_n),
        .frame_out(frame_out),
        .frame_type(frame_type)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            frame_in = 64'b0;
            frame_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unicast Frame Detection", test_num);
            reset_dut();

            @(posedge clk);
            frame_in = 64'h0200_0000_0000_1234;
            frame_valid = 1;

            @(posedge clk);
            frame_valid = 0;
            frame_in = 64'b0;

            #2;
            #1;

            check_outputs(64'h0200_0000_0000_1234, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multicast Frame Detection", test_num);
            reset_dut();

            @(posedge clk);
            frame_in = 64'h0100_5E00_0001_ABCD;
            frame_valid = 1;

            @(posedge clk);
            frame_valid = 0;

            #2;
            #1;

            check_outputs(64'h0100_5E00_0001_ABCD, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Broadcast Frame Detection", test_num);
            reset_dut();

            @(posedge clk);
            frame_in = 64'hFFFF_FFFF_FFFF_0000;
            frame_valid = 1;

            @(posedge clk);
            frame_valid = 0;

            #2;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_0000, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unicast Frame (Zero Prefix)", test_num);
            reset_dut();

            @(posedge clk);
            frame_in = 64'h0010_A344_5566_7788;
            frame_valid = 1;

            @(posedge clk);
            frame_valid = 0;

            #2;
            #1;

            check_outputs(64'h0010_A344_5566_7788, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multicast Frame (High bit set)", test_num);
            reset_dut();

            @(posedge clk);
            frame_in = 64'hFDFF_FFFF_FFFF_EEEE;
            frame_valid = 1;

            @(posedge clk);
            frame_valid = 0;

            #2;
            #1;

            check_outputs(64'hFDFF_FFFF_FFFF_EEEE, 2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_mac_controller Testbench");
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
        input [63:0] expected_frame_out;
        input [1:0] expected_frame_type;
        begin
            if (expected_frame_out === (expected_frame_out ^ frame_out ^ expected_frame_out) &&
                expected_frame_type === (expected_frame_type ^ frame_type ^ expected_frame_type)) begin
                $display("PASS");
                $display("  Outputs: frame_out=%h, frame_type=%h",
                         frame_out, frame_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_out=%h, frame_type=%h",
                         expected_frame_out, expected_frame_type);
                $display("  Got:      frame_out=%h, frame_type=%h",
                         frame_out, frame_type);
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
        $dumpvars(0,clk, frame_in, frame_valid, rst_n, frame_out, frame_type);
    end

endmodule
