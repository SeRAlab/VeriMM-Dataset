`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] addra;
    reg clka;
    wire [35:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .douta(douta)
    );
    task reset_inputs;

        begin
            addra = 10'b0;
            @(posedge clka);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Starting testcase001: Read Address 0x000");
            reset_inputs();

            addra = 10'h000;
            @(posedge clka);
            #2;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Starting testcase002: Read Address 0x3FF (Boundary)");
            reset_inputs();

            addra = 10'h3FF;
            @(posedge clka);
            #2;
            #1;

            check_outputs(36'h0000003FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Starting testcase003: Read Address 0x200");
            reset_inputs();

            addra = 10'h200;
            @(posedge clka);
            #2;
            #1;

            check_outputs(36'h000000200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Starting testcase004: Read Address 0x155");
            reset_inputs();

            addra = 10'h155;
            @(posedge clka);
            #2;
            #1;

            check_outputs(36'h000000155);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Starting testcase005: Read Address 0x2AA");
            reset_inputs();

            addra = 10'h2AA;
            @(posedge clka);
            #2;
            #1;

            check_outputs(36'h0000002AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Starting testcase006: Sequential Back-to-Back Access");
            reset_inputs();

            addra = 10'h00A;
            @(posedge clka);
            #1;
            addra = 10'h00B;


            #1;
            #1;

            check_outputs(36'h00000000A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [35:0] expected_douta;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%h",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h",
                         expected_douta);
                $display("  Got:      douta=%h",
                         douta);
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
