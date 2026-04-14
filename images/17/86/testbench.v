`timescale 1ns/1ps

module tcp_segmentation_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] mss;
    reg [15:0] payload_size;
    reg reset;
    wire segment_required;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmentation_controller dut (
        .clk(clk),
        .mss(mss),
        .payload_size(payload_size),
        .reset(reset),
        .segment_required(segment_required)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            mss = 0;
            payload_size = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Payload < MSS", test_num);
            reset_dut();
            mss = 16'd1460;
            payload_size = 16'd500;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Payload == MSS", test_num);
            reset_dut();
            mss = 16'd1460;
            payload_size = 16'd1460;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Payload > MSS (Boundary + 1)", test_num);
            reset_dut();
            mss = 16'd1460;
            payload_size = 16'd1461;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Payload and MSS", test_num);
            reset_dut();
            mss = 16'hFFFF;
            payload_size = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Payload", test_num);
            reset_dut();
            mss = 16'd1000;
            payload_size = 16'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum MSS (1)", test_num);
            reset_dut();
            mss = 16'd1;
            payload_size = 16'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);

            reset = 1;
            mss = 16'd500;
            payload_size = 16'd1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
            reset = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Input Change", test_num);
            reset_dut();
            mss = 16'd1000;
            payload_size = 16'd1200;
            @(posedge clk);
            #1;

            mss = 16'd1500;
            @(posedge clk);
            #1 #1;
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
        $display("tcp_segmentation_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_segment_required;
        begin
            if (expected_segment_required === (expected_segment_required ^ segment_required ^ expected_segment_required)) begin
                $display("PASS");
                $display("  Outputs: segment_required=%b",
                         segment_required);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segment_required=%b",
                         expected_segment_required);
                $display("  Got:      segment_required=%b",
                         segment_required);
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
        $dumpvars(0,clk, mss, payload_size, reset, segment_required);
    end

endmodule
