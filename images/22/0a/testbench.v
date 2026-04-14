`timescale 1ns/1ps

module memory_allocator_tb;

    // Testbench signals (combinational circuit)
    reg free;
    reg [2:0] req;
    wire alloc_success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_allocator dut (
        .free(free),
        .req(req),
        .alloc_success(alloc_success)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Single allocation within limits (5 bytes)");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd5; #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Fill memory exactly (4 bytes then 4 bytes)");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd4; #10;
            req = 3'd4; #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Over-allocate memory (5 bytes then 4 bytes)");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd5; #10;
            req = 3'd4; #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Verify free functionality");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd7; #10;

            free = 1; #10;
            free = 0;

            req = 3'd7; #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multiple small allocations");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd2; #10;
            req = 3'd2; #10;
            req = 3'd2; #10;
            req = 3'd2; #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Request 0 bytes");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd0; #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Allocation failure after saturation");

            free = 1; req = 0; #10;
            free = 0;

            req = 3'd7; #10;

            req = 3'd2; #10;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_allocator Testbench");
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
        input expected_alloc_success;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alloc_success === (expected_alloc_success ^ alloc_success ^ expected_alloc_success)) begin
                $display("PASS");
                $display("  Outputs: alloc_success=%b",
                         alloc_success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alloc_success=%b",
                         expected_alloc_success);
                $display("  Got:      alloc_success=%b",
                         alloc_success);
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
