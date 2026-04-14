`timescale 1ns/1ps

module pcie_decoder_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [1:0] pcie_ctl;
    reg [7:0] pcie_data;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_decoder dut (
        .clk(clk),
        .pcie_ctl(pcie_ctl),
        .pcie_data(pcie_data),
        .data_out(data_out)
    );
    task reset_interface;

        begin
            pcie_ctl = 2'b00;
            pcie_data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: Data Pass-through (ctl=01)");
            reset_interface();

            pcie_ctl = 2'b01;
            pcie_data = 8'hA5;
            @(posedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: Zeroing Logic (ctl=00)");
            reset_interface();


            pcie_ctl = 2'b01;
            pcie_data = 8'hFF;
            @(posedge clk);


            pcie_ctl = 2'b00;
            pcie_data = 8'hFF;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: Hold Logic (ctl=10)");
            reset_interface();


            pcie_ctl = 2'b01;
            pcie_data = 8'h55;
            @(posedge clk);


            pcie_ctl = 2'b10;
            pcie_data = 8'hAA;
            @(posedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Hold Logic (ctl=11)");
            reset_interface();


            pcie_ctl = 2'b01;
            pcie_data = 8'h33;
            @(posedge clk);


            pcie_ctl = 2'b11;
            pcie_data = 8'hCC;
            @(posedge clk);

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: Hold Zero State");
            reset_interface();


            pcie_ctl = 2'b10;
            pcie_data = 8'hEE;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase006: Rapid Transitions");
            reset_interface();


            pcie_ctl = 2'b01; pcie_data = 8'h11; @(posedge clk);

            pcie_ctl = 2'b10; pcie_data = 8'h22; @(posedge clk);

            pcie_ctl = 2'b00; pcie_data = 8'h33; @(posedge clk);

            pcie_ctl = 2'b11; pcie_data = 8'h44; @(posedge clk);

            pcie_ctl = 2'b01; pcie_data = 8'h55; @(posedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_decoder Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
