`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_req;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .read_req(read_req),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_req = 0;
            @(posedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Read Request", test_num);
            reset_dut();

            @(posedge clk);
            read_req <= 1;
            @(posedge clk);
            read_req <= 0;

            #1;

            #1;


            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: No Read Request", test_num);
            reset_dut();

            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Continuous Read Request", test_num);
            reset_dut();

            @(posedge clk);
            read_req <= 1;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Recovery to Idle", test_num);
            reset_dut();


            @(posedge clk);
            read_req <= 1;
            @(posedge clk);


            read_req <= 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Fast Toggle Request", test_num);
            reset_dut();

            @(posedge clk);
            read_req <= 1;
            @(posedge clk);
            read_req <= 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, read_req, data_out);
    end

endmodule
