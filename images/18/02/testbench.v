`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] incoming_ip;
    reg translate;
    wire [31:0] outgoing_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .incoming_ip(incoming_ip),
        .translate(translate),
        .outgoing_ip(outgoing_ip)
    );

    // Clock generation (10ns period)
    initial begin
        translate = 0;
        forever #5 translate = ~translate;
    end

        task reset_dut;

        begin
            rst_n = 0;
            incoming_ip = 0;
            translate = 0;
            @(posedge clk);
            @(posedge clk);
            #1 rst_n = 1;
            $display("--- Reset Cycle Completed ---");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Translation Mapping 1 (192.168.1.1 -> 10.0.0.1)", test_num);
            incoming_ip = 32'hC0A80101;
            translate = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0A000001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Translation Mapping 2 (192.168.1.2 -> 10.0.0.2)", test_num);
            incoming_ip = 32'hC0A80102;
            translate = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0A000002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Pass-through Mode (Translate=0, IP=192.168.1.1)", test_num);
            incoming_ip = 32'hC0A80101;
            translate = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Pass-through Mode (Translate=0, IP=192.168.1.2)", test_num);
            incoming_ip = 32'hC0A80102;
            translate = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hC0A80102);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Unmapped IP Pass-through (Translate=1, IP=172.16.0.5)", test_num);
            incoming_ip = 32'hAC100005;
            translate = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAC100005);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Arbitrary External IP (Translate=0, IP=8.8.8.8)", test_num);
            incoming_ip = 32'h08080808;
            translate = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
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
        input [31:0] expected_outgoing_ip;
        begin
            if (expected_outgoing_ip === (expected_outgoing_ip ^ outgoing_ip ^ expected_outgoing_ip)) begin
                $display("PASS");
                $display("  Outputs: outgoing_ip=%h",
                         outgoing_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outgoing_ip=%h",
                         expected_outgoing_ip);
                $display("  Got:      outgoing_ip=%h",
                         outgoing_ip);
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
        $dumpvars(0,incoming_ip, translate, outgoing_ip);
    end

endmodule
