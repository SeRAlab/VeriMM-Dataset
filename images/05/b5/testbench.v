`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [47:0] dest_addr;
    reg [47:0] mac_addr;
    reg rst;
    wire frame_received;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .mac_addr(mac_addr),
        .rst(rst),
        .frame_received(frame_received)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        dest_addr = 48'b0;
        mac_addr = 48'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Exact MAC Address Match", test_num);
        reset_dut();
        dest_addr = 48'hAABBCCDDEEFF;
        mac_addr  = 48'hAABBCCDDEEFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MAC Address Mismatch", test_num);
        reset_dut();
        dest_addr = 48'h0123456789AB;
        mac_addr  = 48'hFEDCBA987654;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Near-Miss (One bit off)", test_num);
        reset_dut();
        dest_addr = 48'hFFFFFFFFFFFF;
        mac_addr  = 48'hFFFFFFFFFFFE;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Zeros Match", test_num);
        reset_dut();
        dest_addr = 48'h000000000000;
        mac_addr  = 48'h000000000000;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Output during Reset", test_num);

        rst = 1;
        dest_addr = 48'h111111111111;
        mac_addr  = 48'h111111111111;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b0);
        rst = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Broadcast Address Match", test_num);
        reset_dut();
        dest_addr = 48'hFFFFFFFFFFFF;
        mac_addr  = 48'hFFFFFFFFFFFF;
        @(posedge clk);
        #1 #1;
 check_outputs(1'b1);
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
        input expected_frame_received;
        begin
            if (expected_frame_received === (expected_frame_received ^ frame_received ^ expected_frame_received)) begin
                $display("PASS");
                $display("  Outputs: frame_received=%b",
                         frame_received);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_received=%b",
                         expected_frame_received);
                $display("  Got:      frame_received=%b",
                         frame_received);
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
        $dumpvars(0,clk, dest_addr, mac_addr, rst, frame_received);
    end

endmodule
