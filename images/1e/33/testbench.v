`timescale 1ns/1ps

module pcie_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [3:0] data_valid;
    wire [63:0] received_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_receiver dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .received_data(received_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 64'b0;
            data_valid = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Data Capture", test_num);
            reset_dut();

            data_in = 64'hDEADBEEFCAFEBABE;
            data_valid = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hDEADBEEFCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data Persistence", test_num);
            reset_dut();


            data_in = 64'h1111222233334444;
            data_valid = 4'hF;
            @(posedge clk);
            #1;


            data_in = 64'hFFFFFFFFFFFFFFFF;
            data_valid = 4'h0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(64'h1111222233334444);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Partial Valid Signal (4'b0001)", test_num);
            reset_dut();

            data_in = 64'hAAAA5555AAAA5555;
            data_valid = 4'b0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hAAAA5555AAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Successive Writes", test_num);
            reset_dut();


            data_in = 64'h0102030405060708;
            data_valid = 4'hF;
            @(posedge clk);
            #1;


            data_in = 64'h090A0B0C0D0E0F00;
            data_valid = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h090A0B0C0D0E0F00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Data Capture", test_num);
            reset_dut();


            data_in = 64'hFFFFFFFFFFFFFFFF;
            data_valid = 4'hF;
            @(posedge clk);
            #1;


            data_in = 64'h0000000000000000;
            data_valid = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_receiver Testbench");
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
        input [63:0] expected_received_data;
        begin
            if (expected_received_data === (expected_received_data ^ received_data ^ expected_received_data)) begin
                $display("PASS");
                $display("  Outputs: received_data=%h",
                         received_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: received_data=%h",
                         expected_received_data);
                $display("  Got:      received_data=%h",
                         received_data);
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
        $dumpvars(0,clk, data_in, data_valid, received_data);
    end

endmodule
