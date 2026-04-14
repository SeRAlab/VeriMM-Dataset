`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] addr;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_16bit dut (
        .addr(addr),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Address 0x0", test_num);
            addr = 4'h0;
            data_in = 16'hABCD;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read at Boundary Address 0xF", test_num);
            addr = 4'hF;
            data_in = 16'h1234;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwriting an existing memory location", test_num);

            addr = 4'h5;
            data_in = 16'h5555;
            we = 1;
            #10;

            data_in = 16'hAAAA;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verification of data independence (Address 0x1 vs 0x2)", test_num);

            addr = 4'h1;
            data_in = 16'h1111;
            we = 1;
            #10;

            addr = 4'h2;
            data_in = 16'h2222;
            we = 1;
            #10;

            addr = 4'h1;
            we = 0;
            #10;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All-ones and All-zeros data pattern test", test_num);

            addr = 4'hA;
            data_in = 16'hFFFF;
            we = 1;
            #10;
            we = 0;
            #5;

            addr = 4'hB;
            data_in = 16'h0000;
            we = 1;
            #10;
            we = 0;
            #10;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Read from an address written in a previous task (0xA)", test_num);
            addr = 4'hA;
            we = 0;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_16bit Testbench");
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
        input [15:0] expected_data_out;
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
