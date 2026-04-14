`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    reg tx_en;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .tx_en(tx_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            tx_en = 0;
            data_in = 64'h0;

            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transmit Activity Check", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 1;
            data_in = 64'hCAFE_BABE_DEAD_BEEF;
            @(posedge clk);
            #1 tx_en = 0;
            data_in = 64'h0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Input Isolation (tx_en=0)", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 0;
            data_in = 64'h1122_3344_5566_7788;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Transmit operations", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 1;
            data_in = 64'h0000_0000_0000_0001;
            @(posedge clk);
            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            tx_en = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during Active Transmit", test_num);
            reset_dut();

            @(posedge clk);
            tx_en = 1;
            data_in = 64'h5555_AAAA_5555_AAAA;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            repeat(1) @(posedge clk);
            #1;

            check_outputs(64'h0);
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
        input [63:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, tx_en, data_out);
    end

endmodule
