`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frame_data;
    reg [3:0] frame_length;
    reg reset;
    reg transmit_req;
    wire tx_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_length(frame_length),
        .reset(reset),
        .transmit_req(transmit_req),
        .tx_complete(tx_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frame_data = 0;
            frame_length = 0;
            transmit_req = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Minimum Frame Length (1)", test_num);

            frame_data = 8'hA1;
            frame_length = 4'd1;
            @(posedge clk);
            #1 transmit_req = 1;
            @(posedge clk);
            #1 transmit_req = 0;



            fork : timeout_001
                begin
                    wait(tx_complete == 1'b1);
                    disable timeout_001;
                end
                begin
                    repeat(10) @(posedge clk);
                    disable timeout_001;
                end
            join

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Typical Frame Length (8)", test_num);

            frame_data = 8'hBC;
            frame_length = 4'd8;
            @(posedge clk);
            #1 transmit_req = 1;
            @(posedge clk);
            #1 transmit_req = 0;


            fork : timeout_002
                begin
                    wait(tx_complete == 1'b1);
                    disable timeout_002;
                end
                begin
                    repeat(25) @(posedge clk);
                    disable timeout_002;
                end
            join

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Maximum Frame Length (15)", test_num);

            frame_data = 8'hFF;
            frame_length = 4'd15;
            @(posedge clk);
            #1 transmit_req = 1;
            @(posedge clk);
            #1 transmit_req = 0;

            fork : timeout_003
                begin
                    wait(tx_complete == 1'b1);
                    disable timeout_003;
                end
                begin
                    repeat(40) @(posedge clk);
                    disable timeout_003;
                end
            join

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Data stability test", test_num);

            frame_data = 8'h55;
            frame_length = 4'd4;
            @(posedge clk);
            #1 transmit_req = 1;
            @(posedge clk);
            #1 transmit_req = 0;
            frame_data = 8'h00;

            fork : timeout_004
                begin
                    wait(tx_complete == 1'b1);
                    disable timeout_004;
                end
                begin
                    repeat(20) @(posedge clk);
                    disable timeout_004;
                end
            join

            #1;


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
        input expected_tx_complete;
        begin
            if (expected_tx_complete === (expected_tx_complete ^ tx_complete ^ expected_tx_complete)) begin
                $display("PASS");
                $display("  Outputs: tx_complete=%b",
                         tx_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_complete=%b",
                         expected_tx_complete);
                $display("  Got:      tx_complete=%b",
                         tx_complete);
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
        $dumpvars(0,clk, frame_data, frame_length, reset, transmit_req, tx_complete);
    end

endmodule
