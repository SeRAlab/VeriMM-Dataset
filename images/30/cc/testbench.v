`timescale 1ns/1ps

module mac_address_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [47:0] incoming_mac;
    reg rst_n;
    reg [47:0] stored_mac;
    wire traffic_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_filter dut (
        .clk(clk),
        .enable(enable),
        .incoming_mac(incoming_mac),
        .rst_n(rst_n),
        .stored_mac(stored_mac),
        .traffic_allowed(traffic_allowed)
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
        incoming_mac = 48'b0;
        stored_mac = 48'b0;
        #20;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'hA1B2C3D4E5F6;
        incoming_mac = 48'hA1B2C3D4E5F6;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 001: Matching MAC, Enable High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'hA1B2C3D4E5F6;
        incoming_mac = 48'hA1B2C3D4E5F6;
        enable = 0;
        @(posedge clk);
        #2;
        $display("Test 002: Matching MAC, Enable Low");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'hA1B2C3D4E5F6;
        incoming_mac = 48'hDEADBEEFCAFE;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 003: Non-matching MAC, Enable High");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'h000000000000;
        incoming_mac = 48'h000000000000;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 004: All Zeros MAC Match, Enable High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'hFFFFFFFFFFFF;
        incoming_mac = 48'hFFFFFFFFFFFF;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 005: Broadcast MAC Match, Enable High");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac   = 48'hA1B2C3D4E5F6;
        incoming_mac = 48'hA1B2C3D4E5F7;
        enable = 1;
        @(posedge clk);
        #2;
        $display("Test 006: 1-bit Mismatch, Enable High");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        @(posedge clk);
        stored_mac = 48'h123456789ABC;
        incoming_mac = 48'h123456789ABC;
        enable = 1;
        @(posedge clk);
        #2;
        enable = 0;
        @(posedge clk);
        #2;
        $display("Test 007: Toggle Enable Low after matching");
        #1;

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
        $display("mac_address_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_traffic_allowed;
        begin
            if (expected_traffic_allowed === (expected_traffic_allowed ^ traffic_allowed ^ expected_traffic_allowed)) begin
                $display("PASS");
                $display("  Outputs: traffic_allowed=%b",
                         traffic_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: traffic_allowed=%b",
                         expected_traffic_allowed);
                $display("  Got:      traffic_allowed=%b",
                         traffic_allowed);
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
        $dumpvars(0,clk, enable, incoming_mac, rst_n, stored_mac, traffic_allowed);
    end

endmodule
