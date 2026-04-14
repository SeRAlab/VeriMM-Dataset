`timescale 1ns/1ps

module page_table_translation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] virtual_page;
    wire [3:0] physical_frame;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    page_table_translation dut (
        .clk(clk),
        .virtual_page(virtual_page),
        .physical_frame(physical_frame),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            virtual_page = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            virtual_page = 4'h0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Translation for VPN 0", test_num);

            #1;


            check_outputs(4'h5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            virtual_page = 4'h1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Translation for VPN 1", test_num);

            #1;


            check_outputs(4'h3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            virtual_page = 4'h2;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Translation for VPN 2", test_num);

            #1;


            check_outputs(4'hC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            virtual_page = 4'h3;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Translation for VPN 3", test_num);

            #1;


            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            virtual_page = 4'h8;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Invalid Access for VPN 8", test_num);

            #1;


            check_outputs(physical_frame, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            virtual_page = 4'hF;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Boundary Check VPN 15", test_num);

            #1;


            check_outputs(4'h1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            virtual_page = 4'h1;
            @(posedge clk);
            #1;
            virtual_page = 4'h0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Consecutive Lookups (Final check VPN 0)", test_num);
            #1;

            check_outputs(4'h5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("page_table_translation Testbench");
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
        input [3:0] expected_physical_frame;
        input expected_valid;
        begin
            if (expected_physical_frame === (expected_physical_frame ^ physical_frame ^ expected_physical_frame) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: physical_frame=%h, valid=%b",
                         physical_frame, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_frame=%h, valid=%b",
                         expected_physical_frame, expected_valid);
                $display("  Got:      physical_frame=%h, valid=%b",
                         physical_frame, valid);
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
        $dumpvars(0,clk, virtual_page, physical_frame, valid);
    end

endmodule
