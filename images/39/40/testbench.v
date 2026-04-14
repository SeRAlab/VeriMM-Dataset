`timescale 1ns/1ps

module pcie_tlp_processor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] tlp_in;
    reg valid;
    wire [3:0] tlp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_tlp_processor dut (
        .tlp_in(tlp_in),
        .valid(valid),
        .tlp_out(tlp_out)
    );

    // Clock generation (10ns period)
    initial begin
        valid = 0;
        forever #5 valid = ~valid;
    end

        task reset_dut;

    begin
        tlp_in = 8'h00;


        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        tlp_in = 8'hA5;
        #5;
        test_num = 1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        tlp_in = 8'h2B;
        #5;
        test_num = 2;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        tlp_in = 8'hC3;
        #5;

        #5;
        tlp_in = 8'hF0;
        #2;
        test_num = 3;

        #1;


        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        tlp_in = 8'h0F;
        #5;
        test_num = 4;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        tlp_in = 8'hF0;
        #5;
        test_num = 5;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();

        tlp_in = 8'h11;
        #5;
        #5;
        tlp_in = 8'h55;
        #5;
        test_num = 6;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        reset_dut();


        tlp_in = 8'h8F;
        #5;
        test_num = 7;
        #1;

        check_outputs(4'h8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_tlp_processor Testbench");
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
        input [3:0] expected_tlp_out;
        begin
            if (expected_tlp_out === (expected_tlp_out ^ tlp_out ^ expected_tlp_out)) begin
                $display("PASS");
                $display("  Outputs: tlp_out=%h",
                         tlp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tlp_out=%h",
                         expected_tlp_out);
                $display("  Got:      tlp_out=%h",
                         tlp_out);
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
        $dumpvars(0,tlp_in, valid, tlp_out);
    end

endmodule
