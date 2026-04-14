`timescale 1ns/1ps

module pcie_endpoint_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req;
    reg reset;
    wire ack;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .ack(ack),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Read Request", test_num);
            reset_dut();

            @(posedge clk);
            req = 1;


            fork : wait_for_ack
                begin
                    wait(ack === 1'b1);

                    @(posedge clk);
                    #1;
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable wait_for_ack;



            #1;




            check_outputs(1'b1, 32'h12345678);

            req = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Idle State Check", test_num);
            reset_dut();

            req = 0;

            repeat(10) @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reset During Request", test_num);
            reset_dut();

            @(posedge clk);
            req = 1;


            repeat(2) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'h00000000);
            reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Immediate Request After Reset", test_num);
            reset_dut();


            req = 1;


            fork : wait_for_ack_b2b
                begin
                    wait(ack === 1'b1);
                    @(posedge clk);
                    #1;
                end
                begin
                    repeat(20) @(posedge clk);
                end
            join_any
            disable wait_for_ack_b2b;

            #1;


            check_outputs(1'b1, 32'h12345678);
            req = 0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint Testbench");
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
        input expected_ack;
        input [31:0] expected_read_data;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, read_data=%h",
                         ack, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, read_data=%h",
                         expected_ack, expected_read_data);
                $display("  Got:      ack=%b, read_data=%h",
                         ack, read_data);
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
        $dumpvars(0,clk, req, reset, ack, read_data);
    end

endmodule
