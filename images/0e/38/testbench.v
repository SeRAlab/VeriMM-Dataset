`timescale 1ns/1ps

module simple_DES_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [63:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_DES dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Data and Key)", test_num);
            data_in = 64'h0000_0000_0000_0000;
            key     = 64'h0000_0000_0000_0000;


            #1;



            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (Data and Key)", test_num);
            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            key     = 64'hFFFF_FFFF_FFFF_FFFF;

            #1;


            check_outputs(64'h7C1B2A10F0A5D89E);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            data_in = 64'h5555_5555_5555_5555;
            key     = 64'hAAAA_AAAA_AAAA_AAAA;

            #1;


            check_outputs(64'h21A30E5B6D12C097);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern B", test_num);
            data_in = 64'hAAAA_AAAA_AAAA_AAAA;
            key     = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(64'hD4E5B1A029C837F4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard DES Example Vector", test_num);

            data_in = 64'h0123_4567_89AB_CDEF;
            key     = 64'h1334_5779_9BBC_DFF1;








            #1;









            check_outputs(64'hDA02_CE3A_89AB_CDEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_DES Testbench");
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
